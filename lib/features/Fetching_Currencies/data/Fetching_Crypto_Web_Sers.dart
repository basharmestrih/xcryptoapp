import 'dart:convert';
import 'package:flutter_application_1/features/Fetching_Currencies/domain/Fetching_Crypto_Model.dart';
import 'package:http/http.dart' as http;

class CryptoPricesWeb {
  Future<List<CryptoPrices>> fetchCryptoPrices() async {
    final response = await http.get(Uri.parse('https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      // Map each item in the JSON list to a FuelPrice object
      return jsonList.take(100).map((json) => CryptoPrices.fromJson(json)).toList();

      
    } else {
      throw Exception('Failed to load fuel price data');
    }
  }
}
