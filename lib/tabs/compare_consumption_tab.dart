import 'package:flutter/material.dart';
import 'package:useful_services_frontend/models/enum_states.dart';
import 'package:useful_services_frontend/utils/requests.dart';
import 'package:useful_services_frontend/widgets/consumption_convertion_widgets/basic_form.dart';
import 'package:useful_services_frontend/widgets/consumption_convertion_widgets/calculation_button.dart';
import 'package:useful_services_frontend/widgets/consumption_convertion_widgets/consumption_calculator.dart';

class CompareConsumptionTab extends StatefulWidget {
  const CompareConsumptionTab({super.key});

  @override
  State<CompareConsumptionTab> createState() => _CompareConsumptionTabState();
}

class _CompareConsumptionTabState extends State<CompareConsumptionTab> {
  double _consumptionFactor = 0.0;
  double _consumptionFactorGasPrice = 0.0;
  double _consumptionFactorElectricityPrice = 0.0;
  double _gasPrice = 0.0;
  double _electricityPrice = 0.0;
  bool _loading = false;
  bool _showCalculator = false;

  getConsumptionFactor() async {
    setState(() {
      _loading = true;
    });
    Requests.compareConsumption(_gasPrice, _electricityPrice).then((value) {
      setState(() {
        if (value != null) {
          _consumptionFactor = value;
          _consumptionFactorGasPrice = _gasPrice;
          _consumptionFactorElectricityPrice = _electricityPrice;
          _showCalculator = true;
        }
        _loading = false;
      });
    });
  }

  changePrices(double gasPrice, double electricityPrice) {
    setState(() {
      _gasPrice = gasPrice;
      _electricityPrice = electricityPrice;
      if (_gasPrice == _consumptionFactorGasPrice &&
          _electricityPrice == _consumptionFactorElectricityPrice &&
          _consumptionFactor != 0.0) {
        _showCalculator = true;
      } else {
        _showCalculator = false;
      }
    });
  }

  ButtonState getButtonState() {
    if (_loading) {
      return ButtonState.loading;
    } else if (_gasPrice == 0.0 || _electricityPrice == 0.0) {
      return ButtonState.disabled;
    } else if (_showCalculator) {
      return ButtonState.hidden;
    } else {
      return ButtonState.enabled;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 30.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            BasicForm(
              changePrices: changePrices,
              disableFields: _loading,
            ),
            if (!_showCalculator)
              CalculationButton(
                buttonState: getButtonState(),
                onPressed: getConsumptionFactor,
              ),
            if (_showCalculator)
              ConsumptionCalculator(
                consumptionFactor: _consumptionFactor,
                gasPrice: _gasPrice,
                electricityPrice: _electricityPrice,
              ),
          ],
        ),
      ),
    );
  }
}
