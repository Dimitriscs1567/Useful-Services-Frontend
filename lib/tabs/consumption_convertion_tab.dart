import 'package:flutter/material.dart';
import 'package:useful_services_frontend/models/button_state.dart';
import 'package:useful_services_frontend/utils/requests.dart';
import 'package:useful_services_frontend/widgets/consumption_convertion_widgets/basic_form.dart';
import 'package:useful_services_frontend/widgets/consumption_convertion_widgets/calculation_button.dart';
import 'package:useful_services_frontend/widgets/consumption_convertion_widgets/consumption_calculator.dart';

class ConsumptionConvertionTab extends StatefulWidget {
  const ConsumptionConvertionTab({super.key});

  @override
  State<ConsumptionConvertionTab> createState() =>
      _ConsumptionConvertionTabState();
}

class _ConsumptionConvertionTabState extends State<ConsumptionConvertionTab> {
  double _consumptionFactor = 0.0;
  double _gasPrice = 0.0;
  double _electricityPrice = 0.0;
  bool _loading = false;

  void getConsumptionFactor() async {
    setState(() {
      _loading = true;
    });
    Requests.compareConsumption(_gasPrice, _electricityPrice).then((value) {
      setState(() {
        if (value != null) {
          _consumptionFactor = value;
        }
        _loading = false;
      });
    });
  }

  ButtonState getButtonState() {
    if (_loading) {
      return ButtonState.loading;
    } else if (_gasPrice == 0.0 || _electricityPrice == 0.0) {
      return ButtonState.disabled;
    } else {
      return ButtonState.enabled;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 30.0),
      child: Column(
        children: [
          BasicForm(
            changePrices: (gasPrice, electricityPrice) {
              setState(() {
                _gasPrice = gasPrice;
                _electricityPrice = electricityPrice;
              });
            },
          ),
          CalculationButton(
            buttonState: getButtonState(),
            onPressed: getConsumptionFactor,
          ),
          if (_consumptionFactor != 0.0)
            ConsumptionCalculator(
              consumptionFactor: _consumptionFactor,
            ),
        ],
      ),
    );
  }
}
