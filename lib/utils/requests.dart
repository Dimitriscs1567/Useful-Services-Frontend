import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:useful_services_frontend/models/fuel_prices.dart';

class Requests {
  static const mainUrl = "http://localhost:8080/";
  static const consumptionConversionUrl = "${mainUrl}compare_consumption/";

  static Future<List<String>> getSupportedCountries() async {
    var url = Uri.parse("${consumptionConversionUrl}get_supported_countries");
    var response = await http.get(url);
    if (response.statusCode != 200) {
      return [];
    }

    return List<String>.from(jsonDecode(response.body));
  }

  static Future<double?> compareConsumption(
      double gasPrice, double electricityPrice) async {
    var url = Uri.parse("${consumptionConversionUrl}compare_consumption");
    var response = await http.post(
      url,
      body: jsonEncode(
        {"gas_price": gasPrice, "electricity_price": electricityPrice},
      ),
    );

    if (response.statusCode != 200) {
      return null;
    }

    return double.parse(jsonDecode(response.body)['lkm_to_kwhkm'].toString());
  }

  static Future<FuelPrices?> getCountryPrices(String country) async {
    var url = Uri.parse("${consumptionConversionUrl}get_country_prices");
    var response = await http.post(url, body: jsonEncode({"country": country}));
    if (response.statusCode != 200) {
      return null;
    }

    return FuelPrices.fromJson(jsonDecode(response.body));
  }
}
