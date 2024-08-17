import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:useful_services_frontend/models/fuel_prices.dart';
import 'package:useful_services_frontend/utils/requests.dart';

class ConsumptionConvertionTab extends StatefulWidget {
  const ConsumptionConvertionTab({super.key});

  @override
  State<ConsumptionConvertionTab> createState() =>
      _ConsumptionConvertionTabState();
}

class _ConsumptionConvertionTabState extends State<ConsumptionConvertionTab> {
  bool _loading = true;
  final List<String> _allCountries = ['No Country'];
  String _selectedCountry = 'No Country';
  String _selectedChargingType = 'AC';
  final TextEditingController _gasController = TextEditingController();
  final TextEditingController _electricityController = TextEditingController();
  bool _priceFieldsEnabled = true;
  FuelPrices? _countryPrices;

  @override
  void initState() {
    Requests.getSupportedCountries().then((value) {
      setState(() {
        _allCountries.addAll(value);
        _loading = false;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? const Center(child: CircularProgressIndicator())
        : Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
            child: Column(
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
                      if (value != null) {
                        setState(() {
                          _countryPrices = value;
                          _gasController.text = value.gas.toString();
                          _electricityController.text =
                              _selectedChargingType == 'AC'
                                  ? _countryPrices!.ac.toString()
                                  : _countryPrices!.dc.toString();
                          _priceFieldsEnabled = true;
                        });
                      }
                    });
                  },
                  selectedItem: _selectedCountry,
                ),
                const Padding(padding: EdgeInsets.all(10.0)),
                TextField(
                  controller: _gasController,
                  decoration: const InputDecoration(
                    labelText: "Gas price in EUR",
                  ),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  enabled: _priceFieldsEnabled,
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
                          enabled: _priceFieldsEnabled,
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
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        enabled: _priceFieldsEnabled,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
  }
}
