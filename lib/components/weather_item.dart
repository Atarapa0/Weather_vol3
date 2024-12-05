import 'package:flutter/material.dart';

class WeatherItem extends StatelessWidget {
  final int value;
  final String unit;
  final String ImageUrl;

  const WeatherItem({
    super.key,
    required this.value,
    required this.unit,
    required this.ImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          height: 60,
          width: 60,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Image.asset(ImageUrl),
        ),
        const SizedBox(
          height: 8,
        ),
        Text(
          value.toString()+ unit ,
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ],
    );
  }
}