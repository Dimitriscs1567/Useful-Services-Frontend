import 'package:flutter/material.dart';
import 'package:useful_services_frontend/models/enum_states.dart';

class ConsumptionCalculator extends StatefulWidget {
  final double consumptionFactor;
  final double gasPrice;
  final double electricityPrice;

  const ConsumptionCalculator({
    super.key,
    required this.consumptionFactor,
    required this.gasPrice,
    required this.electricityPrice,
  });

  @override
  State<ConsumptionCalculator> createState() => _ConsumptionCalculatorState();
}

class _ConsumptionCalculatorState extends State<ConsumptionCalculator> {
  final _electricityController = TextEditingController();
  final _gasController = TextEditingController();
  var _consumptionFields = [ConsumptionField.gas, ConsumptionField.electricity];
  double _distanceTraveled = 0.0;

  changeConsumptionFieldsOrder() {
    setState(() {
      _consumptionFields = _consumptionFields.reversed.toList();
    });
  }

  String _numberFormat(String number) {
    String newNumber = "";
    int j = 0;
    for (int i = number.length - 1; i >= 0; i--) {
      if (j % 3 == 0 && j > 0) {
        newNumber = " $newNumber";
      }

      newNumber = number[i] + newNumber;
      j++;
    }

    return newNumber;
  }

  String getTraveledText() {
    if (_distanceTraveled == 0.0) {
      return "Adjust the slider to calculate the consumption difference in EUR.";
    }

    double? gasConsumption = double.tryParse(_gasController.text);
    double? electricityConsumption =
        double.tryParse(_electricityController.text);

    if (gasConsumption == null || electricityConsumption == null) {
      return "Adjust the consumption values to calculate the consumption difference in EUR.";
    }

    double gasMoney =
        (_distanceTraveled / 100.0) * gasConsumption * widget.gasPrice;
    double electricityMoney = (_distanceTraveled / 100.0) *
        electricityConsumption *
        widget.electricityPrice;

    int moneyDifference = _consumptionFields[0] == ConsumptionField.gas
        ? gasMoney.round() - electricityMoney.round()
        : electricityMoney.round() - gasMoney.round();

    String res =
        "After ${_numberFormat(_distanceTraveled.round().toString())} km you ";
    res += "will have ";

    if (moneyDifference < 0) {
      res += "saved ";
    } else if (moneyDifference > 0) {
      res += "lost ";
    } else {
      return "Gas and electricity will cost you the same amount.";
    }

    res += "${_numberFormat(moneyDifference.abs().toString())} EUR.";

    return res;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Padding(padding: EdgeInsets.all(12.0)),
        const Text(
          'Consumption Calculator',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const Padding(padding: EdgeInsets.all(8.0)),
        Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Padding(padding: EdgeInsets.all(8.0)),
            _getTextField(_consumptionFields[0]),
            IconButton(
              onPressed: changeConsumptionFieldsOrder,
              icon: const Icon(
                Icons.change_circle_outlined,
                size: 30,
              ),
            ),
            const Padding(padding: EdgeInsets.all(8.0)),
            _getTextField(_consumptionFields[1]),
          ],
        ),
        const Padding(padding: EdgeInsets.all(16.0)),
        Slider(
          value: _distanceTraveled,
          onChanged: (value) {
            setState(() {
              _distanceTraveled = value;
            });
          },
          max: 500000,
          divisions: 50,
          label: "${_numberFormat(_distanceTraveled.round().toString())} km",
        ),
        Text(
          getTraveledText(),
          style: const TextStyle(fontSize: 18),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _getTextField(ConsumptionField fieldType) {
    return Expanded(
      child: TextField(
        controller: fieldType == ConsumptionField.gas
            ? _gasController
            : _electricityController,
        decoration: InputDecoration(
          labelText: fieldType == ConsumptionField.gas
              ? "Gas consumption in l/100km"
              : "Electricity consumption in kWh/100km",
        ),
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        maxLength: 7,
        onChanged: (value) {
          final newValue = double.tryParse(value);
          if (fieldType == _consumptionFields[0] && newValue != null) {
            if (fieldType == ConsumptionField.gas) {
              _electricityController.text =
                  ((newValue * widget.consumptionFactor * 100).round() / 100)
                      .toString();
            } else {
              _gasController.text =
                  ((newValue / widget.consumptionFactor * 100).round() / 100)
                      .toString();
            }
          }
          setState(() {});
        },
      ),
    );
  }
}
