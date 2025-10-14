
import 'package:flutter/material.dart';

class HourlyForecastCard extends StatelessWidget {
  final String time; 
  final String temperature; 
  final IconData icon; 
  const HourlyForecastCard({super.key,
  required this.time,
  required this.temperature,
  required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      child: Card(
        elevation: 6,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(
                time,
                style: const TextStyle(
                  fontSize: 16, 
                  fontWeight: FontWeight.bold
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Icon(icon, size: 32),
              const SizedBox(height: 8),
              Text(temperature, 
              style: const TextStyle(
                fontSize: 14),
                ),
            ],
          ),
        ),
      ),
    );
  }
}