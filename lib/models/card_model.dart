// lib/models/card_model.dart
class CardModel {
  String frontDesign;
  String backDesign;
  bool isFlipped;

  CardModel({
    required this.frontDesign,
    required this.backDesign,
    this.isFlipped = false,
  });
}
