// lib/models/card_model.dart
class CardModel {
  final String identifier; // Unique identifier for matching
  final String imagePath; // Path to the front image
  bool isFaceUp;
  bool isMatched;

  CardModel({
    required this.identifier,
    required this.imagePath,
    this.isFaceUp = false,
    this.isMatched = false,
  });
}
