import 'package:flutter/material.dart';

class TemperatureDisplay extends StatelessWidget {
  final double? temperature;

  TemperatureDisplay({this.temperature});

  @override
  Widget build(BuildContext context) {
    Color cardColor;
    if (temperature != null && temperature! > 25) {
      cardColor = Colors.red;
    } else {
      cardColor = Colors.green;
    }

    return temperature != null
        ? Card(
            color: cardColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Center(
                child: Text(
                  'Temperatura: ${temperature!.toStringAsFixed(1)} °C',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          )
        : SizedBox.shrink();
  }
}
