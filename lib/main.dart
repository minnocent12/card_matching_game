// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/game_provider.dart';
import 'widgets/memory_card.dart';

void main() {
  runApp(const MemoryGameApp());
}

class MemoryGameApp extends StatelessWidget {
  const MemoryGameApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GameProvider(),
      child: MaterialApp(
        title: 'Memory Game',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MemoryGameScreen(),
      ),
    );
  }
}

class MemoryGameScreen extends StatelessWidget {
  const MemoryGameScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context);

    // Listen for victory condition
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (gameProvider.cards.every((card) => card.isMatched)) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Congratulations!'),
              content: Text(
                  'You completed the game in ${gameProvider.secondsElapsed} seconds with a score of ${gameProvider.score}.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    gameProvider.resetGame();
                  },
                  child: const Text('Play Again'),
                ),
              ],
            );
          },
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Memory Game'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              gameProvider.resetGame();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Time: ${gameProvider.secondsElapsed}s',
                    style: const TextStyle(fontSize: 18)),
                Text('Score: ${gameProvider.score}',
                    style: const TextStyle(fontSize: 18)),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4, // 4x4 grid
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              itemCount: gameProvider.cards.length,
              itemBuilder: (context, index) {
                final card = gameProvider.cards[index];
                return MemoryCard(
                  card: card,
                  onTap: () {
                    gameProvider.flipCard(card);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
