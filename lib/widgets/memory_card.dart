// lib/widgets/memory_card.dart
import 'package:flutter/material.dart';
import '../models/card_model.dart';
import 'dart:math';

class MemoryCard extends StatefulWidget {
  final CardModel card;
  final VoidCallback onTap;

  const MemoryCard({required this.card, required this.onTap, Key? key})
      : super(key: key);

  @override
  _MemoryCardState createState() => _MemoryCardState();
}

class _MemoryCardState extends State<MemoryCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
    if (widget.card.isFaceUp || widget.card.isMatched) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(covariant MemoryCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.card.isFaceUp != oldWidget.card.isFaceUp) {
      if (widget.card.isFaceUp) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
    if (widget.card.isMatched != oldWidget.card.isMatched &&
        widget.card.isMatched) {
      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          final isFront = _animation.value > 0.5;
          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.rotationY(_animation.value * pi),
            child: isFront
                ? _buildCardFace(widget.card.imagePath)
                : _buildCardBack(),
          );
        },
      ),
    );
  }

  Widget _buildCardFace(String imagePath) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildCardBack() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(8.0),
        image: const DecorationImage(
          image: AssetImage('lib/assets/images/card_back.png'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
