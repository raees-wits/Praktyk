import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(MaterialApp(home: MemoryMatch(level: "medium"))); // Default level set to "medium" for direct navigation
}

class MemoryMatch extends StatefulWidget {
  final String level;

  MemoryMatch({Key? key, required this.level}) : super(key: key);

  @override
  _MemoryMatchState createState() => _MemoryMatchState();
}

class _MemoryMatchState extends State<MemoryMatch> {
  List<CardModel> cards = [];
  List<GlobalKey<FlipCardState>> cardKeys = [];
  late int crossAxisCount; // To be determined by level

  CardModel? firstCard;
  CardModel? secondCard;

  bool flipBack = false; // flag to prevent flipping more than two cards

  bool gameWon = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    crossAxisCount = widget.level == "easy" ? 2 : 4; // Determines grid based on level
    fetchCardData();
  }


  void fetchCardData() async {
    var matchCollection = FirebaseFirestore.instance.collection('Match The Column');
    var snapshot = await matchCollection.get();
    var documents = snapshot.docs;

    // Assuming each document has an array field "Questions" which is a list of maps
    var allQuestions = documents.map((doc) => doc['Questions']).toList();

    // Flatten the list of lists into a single list containing all question/answer pairs
    var questionPairs = allQuestions.expand((questionList) => questionList).toList();

    // Shuffle the list and take the first 8 pairs
    questionPairs.shuffle();
    int numberOfPairs = widget.level == "easy" ? 4 : 8; // Easy has 4 pairs, medium has 8
    var selectedPairs = questionPairs.take(numberOfPairs).toList();

    // Map selected pairs to CardModels
    var cardPairs = selectedPairs.map((pair) {
      var questionCard = CardModel(text: pair['Question'], pairId: pair['Question']);
      var answerCard = CardModel(text: pair['Answer'], pairId: pair['Question']);
      return [questionCard, answerCard];
    }).expand((pair) => pair).toList();

    // Generate GlobalKeys for the new cards
    var newCardKeys = List.generate(cardPairs.length, (index) => GlobalKey<FlipCardState>());

    cardPairs.shuffle();

    setState(() {
      cards = cardPairs;
      cardKeys = newCardKeys;
      isLoading = false;
    });
  }


  void onCardFlip(index) {
    if (!flipBack) {
      if (firstCard == null) {
        setState(() {
          firstCard = cards[index];
        });
      } else if (secondCard == null && firstCard != cards[index]) {
        setState(() {
          secondCard = cards[index];
        });

        if (firstCard!.pairId == secondCard!.pairId) {
          setState(() {
            firstCard!.isMatched = true;
            secondCard!.isMatched = true;
            firstCard = null;
            secondCard = null;
          });
          checkWinCondition();
        } else {
          flipBack = true; // Prevent flipping more cards
          Timer(Duration(milliseconds: 500), () => flipCardsBack());
        }
      }
    }
  }

  void flipCardsBack() {
    cardKeys[cards.indexOf(firstCard!)].currentState?.toggleCard();
    cardKeys[cards.indexOf(secondCard!)].currentState?.toggleCard();
    setState(() {
      firstCard!.isFlipped = false;
      secondCard!.isFlipped = false;
      firstCard = null;
      secondCard = null;
      flipBack = false; // reset the flag after flipping back
    });
  }

  void checkWinCondition() {
    // If all cards are matched, set the game as won
    if (cards.every((card) => card.isMatched)) {
      setState(() {
        gameWon = true;
      });
    }
  }

  void resetGame() {
    // Reset the loading status and game won flag
    setState(() {
      isLoading = true;  // Show loading spinner while new data is fetched
      gameWon = false;  // Reset game won status
    });

    fetchCardData();  // Fetch new data for the next level
  }

  @override
  Widget build(BuildContext context) {
    double screenPadding = 16.0; // total horizontal padding (8.0 * 2)
    double cardWidth = (MediaQuery.of(context).size.width - screenPadding - (3 * 8.0)) / 4; // 4 cards, 3 spacings of 8.0
    double cardHeight = cardWidth * (widget.level == "easy" ? 1 : 1); // Adjust the multiplier to set height
    double aspectRatio = cardWidth / cardHeight;

    // For 'medium' level, you might want a different card height, hence a different multiplier

    return Scaffold(
      appBar: AppBar(
        title: Text('Memory Match Game - ${widget.level.capitalize()}'),
        backgroundColor: Colors.yellow,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Stack(
        children: [
          GridView.builder(
            padding: const EdgeInsets.all(8.0),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: widget.level == "easy" ? 4 : 4, // Number of columns fixed at 4
              childAspectRatio: aspectRatio, // Use the new aspect ratio
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
            ),
            itemCount: cards.length,
            itemBuilder: (context, index) {
              return FlipCard(
                key: cardKeys[index],
                flipOnTouch: !cards[index].isMatched,
                onFlipDone: (isFlipped) {
                  if (!isFlipped || flipBack) return;
                  setState(() {
                    cards[index].isFlipped = isFlipped;
                  });
                  onCardFlip(index);
                },
                direction: FlipDirection.HORIZONTAL,
                front: Card(
                  color: Colors.blue,
                  child: Center(
                    child: Text('Tap to flip'),
                  ),
                ),
                back: Card(
                  color: Colors.white,
                  child: Center(
                    child: Text(cards[index].text),
                  ),
                ),
              );
            },
          ),
          gameWon ? winOverlay(context) : SizedBox.shrink(),
        ],
      ),
    );
  }



  Widget winOverlay(BuildContext context) {
    return Center(
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.black54,
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              'Congratulations! You have won.',
              style: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold, color: Colors.white),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text('Next Level'),
              onPressed: resetGame,
            )
          ],
        ),
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}

class CardModel {
  String text;
  String pairId; // Use this ID to identify which question matches which answer
  bool isFlipped;
  bool isMatched;

  CardModel({required this.text, required this.pairId, this.isFlipped = false, this.isMatched = false});
}