// lib/widgets/flip_card.dart

import 'package:flutter/material.dart';
import 'dart:math';

class FlipCard extends StatefulWidget {
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
  _FlipCardState createState() => _FlipCardState();
}

class _FlipCardState extends State<FlipCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isFront = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: pi).animate(_controller)
      ..addListener(() {
        setState(() {});
      });

    if (widget.isFlipped) {
      _controller.forward();
      _isFront = false;
    }
  }

  @override
  void didUpdateWidget(covariant FlipCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isFlipped != oldWidget.isFlipped) {
      if (widget.isFlipped) {
        _controller.forward();
        _isFront = false;
      } else {
        _controller.reverse();
        _isFront = true;
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose the controller to free resources
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Flip animation using rotation on Y axis
    return GestureDetector(
      onTap: widget.onTap,
      child: Transform(
        alignment: Alignment.center,
        transform: Matrix4.identity()..rotateY(_animation.value),
        child: _animation.value <= pi / 2
            ? _buildBack()
            : Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()..rotateY(pi),
                child: _buildFront(),
              ),
      ),
    );
  }

  Widget _buildFront() {
    return Card(
      color: Colors.white,
      child: Center(
        child: Text(
          widget.frontDesign,
          style: TextStyle(fontSize: 40),
        ),
      ),
    );
  }

  Widget _buildBack() {
    return Card(
      color: Colors.blue,
      child: Center(
        child: Text(
          widget.backDesign,
          style: TextStyle(fontSize: 40, color: Colors.white),
        ),
      ),
    );
  }
}
