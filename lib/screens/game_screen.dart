// lib/screens/game_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../widgets/flip_card.dart';

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  bool _dialogShown = false; // Prevent multiple dialogs

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final gameProvider = Provider.of<GameProvider>(context);
    if (gameProvider.isGameOver && !_dialogShown) {
      _dialogShown = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showVictoryDialog(gameProvider);
      });
    }
  }

  void _showVictoryDialog(GameProvider gameProvider) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Congratulations!'),
          content: Text(
            'You matched all pairs!\n'
            'Your score: ${gameProvider.score}\n'
            'Time taken: ${gameProvider.elapsedTime} seconds\n'
            'Best Score: ${gameProvider.bestScore}\n'
            'Best Time: ${gameProvider.bestTime} seconds',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    ).then((_) {
      _dialogShown = false; // Reset the flag
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Card Matching Game'),
      ),
      body: Consumer<GameProvider>(
        builder: (context, gameProvider, child) {
          return Column(
            children: [
              // Display Score and Elapsed Time
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Score: ${gameProvider.score}',
                          style: TextStyle(fontSize: 24),
                        ),
                        Text(
                          'Time: ${gameProvider.elapsedTime} s',
                          style: TextStyle(fontSize: 24),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    // Display Best Score and Best Time
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Best Score: ${gameProvider.bestScore}',
                          style: TextStyle(fontSize: 20, color: Colors.green),
                        ),
                        Text(
                          'Best Time: ${gameProvider.bestTime} s',
                          style: TextStyle(fontSize: 20, color: Colors.green),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        gameProvider.resetGame(); // Reset game when pressed
                      },
                      child: Text('Restart Game'),
                    ),
                  ],
                ),
              ),
              // Grid of Cards
              Expanded(
                child: GridView.builder(
                  padding: EdgeInsets.all(16),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    childAspectRatio: 1.0,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                  ),
                  itemCount: gameProvider.cards.length,
                  itemBuilder: (context, index) {
                    final card = gameProvider.cards[index];
                    return FlipCard(
                      frontDesign: card.frontDesign,
                      backDesign: card.backDesign,
                      isFlipped: card.isFlipped,
                      onTap: () {
                        gameProvider.flipCard(card, context);
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
