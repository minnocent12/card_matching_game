import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../widgets/flip_card.dart';

class GameScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Card Matching Game'),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
        ),
        itemCount: gameProvider.cards.length,
        itemBuilder: (context, index) {
          final card = gameProvider.cards[index];
          return FlipCard(
            frontDesign: card.frontDesign,
            backDesign: card.backDesign,
            isFlipped: card.isFlipped,
            onTap: () {
              if (!card.isFlipped) {
                gameProvider.flipCard(card);
              }
            },
          );
        },
      ),
    );
  }
}
