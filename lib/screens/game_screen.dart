import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';

class GameScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Card Matching Game'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text('Score: ${gameProvider.score}',
                    style: TextStyle(fontSize: 24)),
                Text('Elapsed Time: ${gameProvider.elapsedTime} seconds',
                    style: TextStyle(fontSize: 24)),
                SizedBox(height: 20),
                // Display best score and best time
                Text('Best Score: ${gameProvider.bestScore}',
                    style: TextStyle(fontSize: 24)),
                Text('Best Time: ${gameProvider.bestTime} seconds',
                    style: TextStyle(fontSize: 24)),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    gameProvider.resetGame(); // Reset game when button pressed
                  },
                  child: Text('Restart Game'),
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                childAspectRatio: 1.0,
              ),
              itemCount: gameProvider.cards.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () =>
                      gameProvider.flipCard(gameProvider.cards[index], context),
                  child: Card(
                    child: Center(
                      child: Text(
                        gameProvider.cards[index].isFlipped
                            ? gameProvider.cards[index].frontDesign
                            : gameProvider.cards[index].backDesign,
                        style: TextStyle(fontSize: 40),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
