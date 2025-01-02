
import 'package:flutter_application_1/features/Fetching_Currencies/domain/Fetching_Crypto_Model.dart';
import 'package:flutter_application_1/features/Fetching_Currencies/data/Fetching_Crypto_Web_Sers.dart';

class CryptoPricesRepository {
  final CryptoPricesWeb service;

  CryptoPricesRepository(this.service);

  Future<List<CryptoPrices>> getCryptoPrices() async {
    return await service.fetchCryptoPrices();
  }
}
