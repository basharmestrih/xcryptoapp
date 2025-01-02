// States for FuelPriceCubit
import 'package:flutter_application_1/features/Fetching_Currencies/domain/Fetching_Crypto_Model.dart';

abstract class CryptoPricesState {}

class CryptoPricesInitial extends CryptoPricesState {}

class CryptoPricesLoading extends CryptoPricesState {}

class CryptoPricesLoaded extends CryptoPricesState {
  final List<CryptoPrices> cryptoPrice;

 CryptoPricesLoaded(this.cryptoPrice);
}

class CryptoPricesError extends CryptoPricesState {
  final String message;

  CryptoPricesError(this.message);
}

class CryptoPricesFiltered extends CryptoPricesState {
  final List<CryptoPrices> filteredCryptoPrices;

  CryptoPricesFiltered(this.filteredCryptoPrices);
}