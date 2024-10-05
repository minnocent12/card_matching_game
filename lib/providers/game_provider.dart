// lib/providers/game_provider.dart

import 'dart:async';
import 'package:flutter/material.dart';
import '../models/card_model.dart';

class GameProvider with ChangeNotifier {
  List<CardModel> cards = [];
  int score = 0;
  Timer? timer; // Nullable Timer to allow proper cancellation
  int elapsedTime = 0; // Time elapsed in seconds
  int matchedPairs = 0;
  List<CardModel> flippedCards = []; // Currently flipped cards
  bool isGameOver = false; // Game over state

  // Best score and time
  int bestScore = 0;
  int bestTime = 0;

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
    _startTimer(); // Start the timer
    notifyListeners();
  }

  void _startTimer() {
    elapsedTime = 0; // Reset elapsed time
    timer?.cancel(); // Cancel any existing timer
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      elapsedTime++; // Increment elapsed time
      notifyListeners(); // Update UI
    });
  }

  void flipCard(CardModel card, BuildContext context) {
    if (card.isFlipped || isGameOver)
      return; // Prevent flipping already flipped or game over

    card.isFlipped = true; // Flip the card
    flippedCards.add(card); // Add to flipped cards
    notifyListeners();

    if (flippedCards.length == 2) {
      Future.delayed(Duration(milliseconds: 500), () {
        if (flippedCards[0].frontDesign == flippedCards[1].frontDesign) {
          // Match found
          matchedPairs++;
          score += 20; // Increase score

          if (matchedPairs == (cards.length ~/ 2)) {
            // All pairs matched, game over
            isGameOver = true; // Set game over
            timer?.cancel(); // Stop the timer
            _updateBestScores(); // Update best score and time
            notifyListeners(); // Update UI
          }
        } else {
          // Not a match
          score -= 5; // Deduct score
          for (var c in flippedCards) {
            c.isFlipped = false; // Flip back down
          }
        }
        flippedCards.clear(); // Clear flipped cards
        notifyListeners(); // Update UI
      });
    }
  }

  void _updateBestScores() {
    if (score > bestScore) bestScore = score;
    if (elapsedTime < bestTime || bestTime == 0) bestTime = elapsedTime;
  }

  void resetGame() {
    score = 0;
    matchedPairs = 0;
    flippedCards.clear(); // Clear any flipped cards
    _initCards(); // Reinitialize cards
    isGameOver = false;
    notifyListeners();
  }

  @override
  void dispose() {
    timer?.cancel(); // Cancel the timer when disposing
    super.dispose();
  }
}
