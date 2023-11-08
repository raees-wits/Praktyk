import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import 'dart:async';


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

  @override
  void initState() {
    super.initState();

    // Create pairs of questions and answers
    var pairs = List.generate(8, (index) {
      return [
        CardModel(text: 'Question ${index + 1}', pairId: 'Pair ${index + 1}'),
        CardModel(text: 'Answer ${index + 1}', pairId: 'Pair ${index + 1}'),
      ];
    }).expand((pair) => pair).toList();

    // Shuffle the card pairs to randomize their positions.
    pairs.shuffle();

    // Now our card list consists of paired questions and answers, instead of identical words.
    cards = pairs;

    // Initialize the list of GlobalKeys for the cards.
    cardKeys = List.generate(cards.length, (index) => GlobalKey<FlipCardState>());
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
      body: Stack(
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