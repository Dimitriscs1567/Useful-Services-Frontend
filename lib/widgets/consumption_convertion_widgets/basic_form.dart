import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:useful_services_frontend/models/fuel_prices.dart';
import 'package:useful_services_frontend/utils/requests.dart';

class BasicForm extends StatefulWidget {
  final Function(double gasPrice, double electricityPrice) changePrices;
  final bool disableFields;

  const BasicForm({
    super.key,
    required this.changePrices,
    required this.disableFields,
  });

  @override
  State<BasicForm> createState() => _BasicFormState();
}

class _BasicFormState extends State<BasicForm> {
  bool _loading = true;
  final List<String> _allCountries = ['No Country'];
  String _selectedCountry = 'No Country';
  String _selectedChargingType = 'AC';
  bool _priceFieldsEnabled = true;
  FuelPrices? _countryPrices;
  final TextEditingController _gasController = TextEditingController();
  final TextEditingController _electricityController = TextEditingController();

  @override
  void initState() {
    Requests.getSupportedCountries().then((value) {
      setState(() {
        _allCountries.addAll(value);
        _loading = false;
      });
    });

    _gasController.addListener(changePrices);
    _electricityController.addListener(changePrices);

    super.initState();
  }

  changePrices() {
    widget.changePrices(
      double.tryParse(_gasController.text) ?? 0.0,
      double.tryParse(_electricityController.text) ?? 0.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? const Center(child: CircularProgressIndicator())
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownSearch<String>(
                items: _allCountries,
                dropdownDecoratorProps: const DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(
                    labelText: "Choose Country (for autocomplete)",
                  ),
                ),
                popupProps: const PopupProps.menu(
                  showSearchBox: true,
                  showSelectedItems: true,
                  searchDelay: Duration(milliseconds: 0),
                ),
                onChanged: (newCountry) {
                  setState(() {
                    _selectedCountry = newCountry ?? 'No Country';
                    _priceFieldsEnabled = false;
                  });

                  Requests.getCountryPrices(_selectedCountry).then((value) {
                    setState(() {
                      _countryPrices = value;

                      if (value != null) {
                        _gasController.text = value.gas.toString();
                        _electricityController.text =
                            _selectedChargingType == 'AC'
                                ? _countryPrices!.ac.toString()
                                : _countryPrices!.dc.toString();
                      }

                      _priceFieldsEnabled = true;
                    });
                  });
                },
                selectedItem: _selectedCountry,
                enabled: _priceFieldsEnabled && !widget.disableFields,
              ),
              const Padding(padding: EdgeInsets.all(10.0)),
              TextField(
                controller: _gasController,
                decoration: const InputDecoration(
                  labelText: "Gas price in EUR",
                ),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                enabled: _priceFieldsEnabled && !widget.disableFields,
              ),
              const Padding(padding: EdgeInsets.all(12.0)),
              Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      items: const [
                        DropdownMenuItem(
                          value: 'AC',
                          child: Text('AC'),
                        ),
                        DropdownMenuItem(
                          value: 'DC',
                          child: Text('DC'),
                        )
                      ],
                      value: _selectedChargingType,
                      onChanged: (value) {
                        setState(() {
                          _selectedChargingType = value ?? 'AC';
                          if (_countryPrices != null) {
                            _electricityController.text =
                                _selectedChargingType == 'AC'
                                    ? _countryPrices!.ac.toString()
                                    : _countryPrices!.dc.toString();
                          }
                        });
                      },
                      decoration: InputDecoration(
                        labelText: "Type of charging",
                        enabled: _priceFieldsEnabled && !widget.disableFields,
                      ),
                    ),
                  ),
                  const Padding(padding: EdgeInsets.all(8.0)),
                  Expanded(
                    child: TextField(
                      controller: _electricityController,
                      decoration: const InputDecoration(
                        labelText: "Electricity price in EUR",
                      ),
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      enabled: _priceFieldsEnabled && !widget.disableFields,
                    ),
                  ),
                ],
              ),
              const Padding(padding: EdgeInsets.all(24.0)),
            ],
          );
  }
}
