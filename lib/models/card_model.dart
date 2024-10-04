class CardModel {
  final String frontDesign; // The design/image shown when the card is face-up
  final String backDesign; // The design/image shown when the card is face-down
  bool isFlipped; // Whether the card is currently face-up

  CardModel(
      {required this.frontDesign,
      required this.backDesign,
      this.isFlipped = false});
}
