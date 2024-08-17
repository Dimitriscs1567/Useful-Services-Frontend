class FuelPrices {
  late final String country;
  late final double gas;
  late final double ac;
  late final double dc;

  FuelPrices({
    required this.country,
    required this.gas,
    required this.ac,
    required this.dc,
  });

  FuelPrices.fromJson(Map<String, dynamic> json) {
    country = json['Country'];
    gas = json['Gas'];
    ac = double.parse(json['AC'].toString());
    dc = double.parse(json['DC'].toString());
  }
}
