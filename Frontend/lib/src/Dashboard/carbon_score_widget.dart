import 'package:flutter/material.dart';

class CarbonScoreWidget extends StatelessWidget {
  final int carbonScore;
  final double width;
  final double height;

  const CarbonScoreWidget({
    Key? key,
    required this.carbonScore,
    this.width = 100,
    this.height = 100,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          carbonScore.toString(),
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}