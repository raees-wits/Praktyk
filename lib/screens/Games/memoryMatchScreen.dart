import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';

void main() {
  runApp(MaterialApp(home: MemoryMatch()));
}

class MemoryMatch extends StatefulWidget {
  @override
  _MemoryMatchState createState() => _MemoryMatchState();
}

class _MemoryMatchState extends State<MemoryMatch> {
  List<CardModel> cards = [];
  List<GlobalKey<FlipCardState>> cardKeys = []; // Add this line

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
