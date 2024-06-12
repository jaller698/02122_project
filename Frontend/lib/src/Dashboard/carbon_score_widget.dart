import 'package:flutter/material.dart';

// written by // TODO
class CarbonScoreWidget extends StatelessWidget {
  final int carbonScore;
  final double width;
  final double height;

  const CarbonScoreWidget({
    super.key,
    required this.carbonScore,
    this.width = 100,
    this.height = 100,
  });

  get_color(int carbonScore) {
    if (carbonScore < 2000) {
      return const ColorFilter.mode(Colors.green, BlendMode.color);
    } else if (carbonScore < 4000) {
      return const ColorFilter.mode(Colors.yellow, BlendMode.color);
    } else {
      return const ColorFilter.mode(Colors.red, BlendMode.color);
    }
  }

  get_background(int carbonScore) {
    if (carbonScore < 2000) {
      return const Image(image: AssetImage('assets/images/good.jpg'));
    } else if (carbonScore < 4000) {
      return const Image(image: AssetImage('assets/images/bad.jpg'));
    } else if (carbonScore < 6000) {
      return const Image(image: AssetImage('assets/images/waste.jpg'));
    } else {
      return const Image(image: AssetImage('assets/images/Destroyed.jpg'));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (carbonScore <= 0) {
      return Container();
    }
    ;
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        image: DecorationImage(
            image: get_background(carbonScore).image,
            fit: BoxFit.cover,
            colorFilter: get_color(carbonScore)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          carbonScore.toString() + " Tons CO2 per year",
          style: TextStyle(
            color: Colors.grey[800],
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
