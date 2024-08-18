import 'package:flutter/material.dart';
import 'package:useful_services_frontend/models/enum_states.dart';

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
      height: 50,
      child: ElevatedButton(
        onPressed:
            widget.buttonState == ButtonState.enabled ? widget.onPressed : null,
        style: const ButtonStyle(
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
          ),
        ),
        child: widget.buttonState == ButtonState.loading
            ? const CircularProgressIndicator()
            : const Text('Calculate'),
      ),
    );
  }
}
