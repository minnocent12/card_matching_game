// lib/providers/game_provider.dart
import 'dart:async';
import 'package:flutter/material.dart';
import '../models/card_model.dart';
import 'dart:math';

class GameProvider with ChangeNotifier {
  List<CardModel> _cards = [];
  CardModel? _firstSelectedCard;
  CardModel? _secondSelectedCard;
  bool _isBusy = false;

  // Timer and Scoring
  Timer? _timer;
  int _secondsElapsed = 0;
  int _score = 0;

  // Bonus Points
  DateTime? _firstCardFlipTime;

  GameProvider() {
    _initializeGame();
  }

  List<CardModel> get cards => _cards;
  int get secondsElapsed => _secondsElapsed;
  int get score => _score;

  void _initializeGame() {
    _cards = _generateCards();
    _cards.shuffle(Random());
    _startTimer();
  }

  List<CardModel> _generateCards() {
    // Assuming you have 8 unique images for a 4x4 grid
    List<String> imagePaths = [
      'lib/assets/images/card1.png',
      'lib/assets/images/card2.png',
      'lib/assets/images/card3.png',
      'lib/assets/images/card4.png',
      'lib/assets/images/card5.png',
      'lib/assets/images/card6.png',
      'lib/assets/images/card7.png',
      'lib/assets/images/card8.png',
    ];

    List<CardModel> generatedCards = [];

    for (var image in imagePaths) {
      generatedCards.add(CardModel(identifier: image, imagePath: image));
      generatedCards.add(CardModel(identifier: image, imagePath: image));
    }

    return generatedCards;
  }

  void flipCard(CardModel card) {
    if (_isBusy || card.isFaceUp || card.isMatched) return;

    card.isFaceUp = true;
    notifyListeners();

    if (_firstSelectedCard == null) {
      _firstSelectedCard = card;
      _firstCardFlipTime = DateTime.now();
    } else {
      _secondSelectedCard = card;
      final timeDifference =
          DateTime.now().difference(_firstCardFlipTime!).inSeconds;
      if (timeDifference <= 5) {
        // Bonus if matched within 5 seconds
        _score += 5; // Bonus points
      }
      _checkForMatch();
    }
  }

  void _checkForMatch() async {
    _isBusy = true;
    notifyListeners();

    if (_firstSelectedCard!.identifier == _secondSelectedCard!.identifier) {
      _firstSelectedCard!.isMatched = true;
      _secondSelectedCard!.isMatched = true;
      _score += 10; // Award points for a match
    } else {
      await Future.delayed(const Duration(seconds: 1));
      _firstSelectedCard!.isFaceUp = false;
      _secondSelectedCard!.isFaceUp = false;
      _score -= 5; // Deduct points for mismatch
    }

    _firstSelectedCard = null;
    _secondSelectedCard = null;
    _isBusy = false;
    notifyListeners();

    // Check for win condition
    if (_cards.every((card) => card.isMatched)) {
      _stopTimer();
      // Victory handled in UI
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _secondsElapsed++;
      notifyListeners();
    });
  }

  void _stopTimer() {
    _timer?.cancel();
  }

  void resetGame() {
    _stopTimer();
    _initializeGame();
    _secondsElapsed = 0;
    _score = 0;
    _firstSelectedCard = null;
    _secondSelectedCard = null;
    _isBusy = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
