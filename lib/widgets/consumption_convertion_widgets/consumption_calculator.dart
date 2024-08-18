import 'package:flutter/material.dart';

class ConsumptionCalculator extends StatefulWidget {
  final double consumptionFactor;

  const ConsumptionCalculator({super.key, required this.consumptionFactor});

  @override
  State<ConsumptionCalculator> createState() => _ConsumptionCalculatorState();
}

class _ConsumptionCalculatorState extends State<ConsumptionCalculator> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
