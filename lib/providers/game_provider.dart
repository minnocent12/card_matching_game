import 'dart:async';
import 'package:flutter/material.dart';
import '../models/card_model.dart';

class GameProvider with ChangeNotifier {
  List<CardModel> cards = [];
  int score = 0;
  late Timer timer;
  int elapsedTime = 0; // Time elapsed in seconds
  int matchedPairs = 0;
  List<CardModel> flippedCards = []; // Track the currently flipped cards
  bool isGameOver = false; // Track game state for victory

  // Fields to track best score and best time
  int bestScore = 0; // Track best score
  int bestTime = 0; // Track best time

  GameProvider() {
    _initCards();
  }

  void _initCards() {
    cards = [
      CardModel(frontDesign: '🐶', backDesign: '❓'),
      CardModel(frontDesign: '🐶', backDesign: '❓'),
      CardModel(frontDesign: '🐱', backDesign: '❓'),
      CardModel(frontDesign: '🐱', backDesign: '❓'),
      CardModel(frontDesign: '🐻', backDesign: '❓'),
      CardModel(frontDesign: '🐻', backDesign: '❓'),
      CardModel(frontDesign: '🐷', backDesign: '❓'),
      CardModel(frontDesign: '🐷', backDesign: '❓'),
      CardModel(frontDesign: '🐸', backDesign: '❓'),
      CardModel(frontDesign: '🐸', backDesign: '❓'),
      CardModel(frontDesign: '🐵', backDesign: '❓'),
      CardModel(frontDesign: '🐵', backDesign: '❓'),
      CardModel(frontDesign: '🦊', backDesign: '❓'),
      CardModel(frontDesign: '🦊', backDesign: '❓'),
      CardModel(frontDesign: '🦁', backDesign: '❓'),
      CardModel(frontDesign: '🦁', backDesign: '❓'),
    ];
    cards.shuffle(); // Shuffle the cards
    isGameOver = false; // Reset game over state
    _startTimer(); // Start the timer when the game begins
  }

  void _startTimer() {
    elapsedTime = 0; // Reset elapsed time to 0
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      elapsedTime++; // Increment elapsed time every second
      notifyListeners(); // Notify listeners to update UI
    });
  }

  // Flip the card and check for matching logic
  void flipCard(CardModel card, BuildContext context) {
    if (card.isFlipped || isGameOver)
      return; // If card is already flipped or game is over

    card.isFlipped = true; // Flip the card
    flippedCards.add(card); // Add to flipped cards list
    notifyListeners();

    if (flippedCards.length == 2) {
      Future.delayed(Duration(milliseconds: 500), () {
        if (flippedCards[0].frontDesign == flippedCards[1].frontDesign) {
          // Cards match
          matchedPairs++;
          score += 20; // Increase score for matching

          if (matchedPairs == (cards.length ~/ 2)) {
            // Game over condition: all pairs matched
            isGameOver = true; // Set game over state
            timer.cancel(); // Stop the timer when the game ends
            _updateBestScores(); // Update best score and time if necessary
            _showVictoryDialog(context); // Show victory message
          }
        } else {
          score -= 5; // Deduct points for mismatches
          for (var c in flippedCards) {
            c.isFlipped = false; // Flip back down
          }
        }
        flippedCards.clear(); // Clear the list of flipped cards
        notifyListeners(); // Notify listeners to update UI
      });
    }
  }

  // Update the best score and time after game completion
  void _updateBestScores() {
    if (score > bestScore) bestScore = score;
    if (elapsedTime < bestTime || bestTime == 0) bestTime = elapsedTime;
  }

  // Show the victory dialog with the final score and time
  void _showVictoryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Congratulations!'),
          content: Text(
            'You matched all pairs!\n'
            'Your score: $score\n'
            'Time taken: $elapsedTime seconds\n'
            'Best Score: $bestScore\n'
            'Best Time: $bestTime seconds',
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
    );
  }

  // Reset game and reinitialize the cards, score, and timer
  void resetGame() {
    score = 0;
    matchedPairs = 0;
    flippedCards.clear(); // Clear flipped cards
    _initCards(); // Re-initialize cards
    isGameOver = false; // Reset game over state
    notifyListeners();
  }
}
