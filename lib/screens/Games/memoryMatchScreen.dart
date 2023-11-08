import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(MaterialApp(home: MemoryMatch()));
}

class MemoryMatch extends StatefulWidget {
  @override
  _MemoryMatchState createState() => _MemoryMatchState();
}

class _MemoryMatchState extends State<MemoryMatch> {
  List<CardModel> cards = [];
  List<GlobalKey<FlipCardState>> cardKeys = [];

  CardModel? firstCard;
  CardModel? secondCard;

  bool flipBack = false; // flag to prevent flipping more than two cards

  bool gameWon = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
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
    var selectedPairs = questionPairs.take(8).toList();

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
    setState(() {
      // Shuffle cards for the next level
      cards.shuffle();
      // Reset matched status and flip back if needed
      for (var i = 0; i < cards.length; i++) {
        cards[i].isMatched = false;
        // If the card is flipped, toggle it back
        if (cards[i].isFlipped) {
          cardKeys[i].currentState?.toggleCard();
          cards[i].isFlipped = false;
        }
      }
      // Reset game won status
      gameWon = false;
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Memory Match Game'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator()) // Show a loading spinner when data is loading
          : Stack(
        children: [
          GridView.builder(
            padding: const EdgeInsets.all(8.0),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
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

class CardModel {
  String text;
  String pairId; // Use this ID to identify which question matches which answer
  bool isFlipped;
  bool isMatched;

  CardModel({required this.text, required this.pairId, this.isFlipped = false, this.isMatched = false});
}