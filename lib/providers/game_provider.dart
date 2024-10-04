import 'dart:async';
import 'package:flutter/material.dart';
import '../models/card_model.dart';

class GameProvider with ChangeNotifier {
  List<CardModel> cards;
  CardModel? firstCard;
  CardModel? secondCard;
  int matchedPairs = 0;

  GameProvider() : cards = _generateCards()..shuffle();

  // Generate a list of cards with front and back designs
  static List<CardModel> _generateCards() {
    const designs = [
      '🍎', '🍎', // Example card designs (emojis)
      '🍌', '🍌',
      '🍇', '🍇',
      '🍊', '🍊',
      '🍉', '🍉',
      '🍓', '🍓',
      '🍒', '🍒',
      '🍍', '🍍',
    ];

    return designs
        .map((design) => CardModel(frontDesign: design, backDesign: '🃏'))
        .toList();
  }

  void flipCard(CardModel card) {
    if (firstCard == null) {
      firstCard = card;
      card.isFlipped = true; // Flip the card
    } else if (secondCard == null && card != firstCard) {
      secondCard = card;
      card.isFlipped = true; // Flip the card
      notifyListeners();
      checkForMatch();
    }
    notifyListeners();
  }

  void checkForMatch() {
    if (firstCard!.frontDesign == secondCard!.frontDesign) {
      matchedPairs++;
      resetCards();
    } else {
      Future.delayed(Duration(seconds: 1), () {
        firstCard!.isFlipped = false; // Flip back if not a match
        secondCard!.isFlipped = false;
        resetCards();
      });
    }
    notifyListeners();
  }

  void resetCards() {
    firstCard = null;
    secondCard = null;
  }
}
