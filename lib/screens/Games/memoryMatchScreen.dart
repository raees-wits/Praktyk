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

  @override
  void initState() {
    super.initState();

    // Initialize your card list with words and set the initial state.
    // For demonstration, all words are 'Hello'. You should replace them with your word pairs and shuffle.
    cards = List.generate(8, (index) => CardModel(word: 'Word ${index+1}'))..addAll(List.generate(8, (index) => CardModel(word: 'Word ${index+1}')));
    cards.shuffle();

    // Initialize the list of GlobalKeys
    cardKeys = List.generate(cards.length, (index) => GlobalKey<FlipCardState>());
  }

  void onCardFlip(index) {
    if (firstCard == null) {
      setState(() {
        firstCard = cards[index];
      });
    } else if (secondCard == null && firstCard != cards[index]) {
      setState(() {
        secondCard = cards[index];
      });

      if (firstCard!.word == secondCard!.word) {
        setState(() {
          firstCard!.isMatched = true;
          secondCard!.isMatched = true;
          firstCard = null;
          secondCard = null;
        });
      } else {
        // If cards don't match, we start the Timer to flip them back over
        flipBack = true;
        Timer(Duration(milliseconds: 500), () => flipCardsBack());
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Language Learning Game'),
      ),
      body: GridView.builder(
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
            flipOnTouch: !cards[index].isMatched, // Only allow flip if not matched
            onFlipDone: (isFlipped) {
              if (!isFlipped || flipBack) return; // Prevent action if the card is flipping back or if we are in flip back process.

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
                child: Text(cards[index].word),
              ),
            ),
          );
        },
      ),
    );
  }
}


class CardModel {
  String word;
  bool isFlipped;
  bool isMatched;

  CardModel({required this.word, this.isFlipped = false, this.isMatched = false});
}
