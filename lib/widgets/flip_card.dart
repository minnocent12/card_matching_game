import 'package:flutter/material.dart';

class FlipCard extends StatefulWidget {
  final String frontDesign;
  final String backDesign;
  final bool isFlipped;
  final Function onTap;

  FlipCard({
    required this.frontDesign,
    required this.backDesign,
    required this.isFlipped,
    required this.onTap,
  });

  @override
  _FlipCardState createState() => _FlipCardState();
}

class _FlipCardState extends State<FlipCard>
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

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    if (widget.isFlipped) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(FlipCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isFlipped != oldWidget.isFlipped) {
      widget.isFlipped ? _controller.forward() : _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onTap();
      },
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          final isUnderAnimation = _animation.value < 0.5;
          final transform = Matrix4.identity()
            ..setEntry(3, 2, 0.002) // Perspective
            ..rotateY(_animation.value * 3.14); // 180 degrees in radians

          return Transform(
            transform: transform,
            alignment: Alignment.center,
            child: isUnderAnimation
                ? Card(
                    color: Colors.blue,
                    child: Center(
                      child: Text(
                        widget.backDesign,
                        style: TextStyle(fontSize: 50),
                      ),
                    ),
                  )
                : Card(
                    color: Colors.blue,
                    child: Center(
                      child: Text(
                        widget.frontDesign,
                        style: TextStyle(fontSize: 50),
                      ),
                    ),
                  ),
          );
        },
      ),
    );
  }
}
