import 'package:flutter/material.dart';
import 'package:useful_services_frontend/models/button_state.dart';

class CalculationButton extends StatefulWidget {
  final ButtonState buttonState;
  final Function() onPressed;

  const CalculationButton({
    super.key,
    required this.buttonState,
    required this.onPressed,
  });

  @override
  State<CalculationButton> createState() => _CalculationButtonState();
}

class _CalculationButtonState extends State<CalculationButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 45,
      child: ElevatedButton(
        onPressed: widget.onPressed,
        child: const Text('Calculate'),
      ),
    );
  }
}
