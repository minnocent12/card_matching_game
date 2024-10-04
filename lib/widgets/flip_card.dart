import 'package:flutter/material.dart';

class FlipCard extends StatelessWidget {
  final String frontDesign;
  final String backDesign;
  final bool isFlipped;
  final VoidCallback onTap;

  const FlipCard({
    Key? key,
    required this.frontDesign,
    required this.backDesign,
    required this.isFlipped,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        child: isFlipped
            ? Card(
                child: Center(
                  child: Text(
                    frontDesign,
                    style: TextStyle(fontSize: 40),
                  ),
                ),
              )
            : Card(
                child: Center(
                  child: Text(
                    backDesign,
                    style: TextStyle(fontSize: 40),
                  ),
                ),
              ),
      ),
    );
  }
}
