import 'package:flutter_application_1/features/Fetching_Currencies/application/Fetching_Crypto_State.dart';
import 'package:flutter_application_1/features/Fetching_Currencies/domain/Fetching_Crypto_Model.dart';
import 'package:flutter_application_1/features/Fetching_Currencies/data/Fetching_Crypto_Repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CryptoPricesCubit extends Cubit<CryptoPricesState> {
  final CryptoPricesRepository repository;

  List<CryptoPrices> _allFuelPrices = []; // Keep all data here for filtering purposes

  CryptoPricesCubit(this.repository) : super(CryptoPricesLoading());

  // Main function to fetch all currencies
  Future<void> fetchFinalData() async {
    try {
      final cryptoPrices = await repository.getCryptoPrices();
      _allFuelPrices = cryptoPrices; // Store the full data list
      emit(CryptoPricesLoaded(_allFuelPrices));
    } catch (e) {
      emit(CryptoPricesError('Failed to fetch data'));
    }
  }

  // Filter function to get pressed currency
  Future<void> fetchCryptoData(String currencyId) async {
  try {
    final cryptoPrices = await repository.getCryptoPrices();
      _allFuelPrices = cryptoPrices; // Store the full data list
    //print(_allFuelPrices);
    CryptoPrices? selectedCrypto;

    // Iterate over the list to find the currency
    for (var crypto in _allFuelPrices) {
      if (crypto.id == currencyId || crypto.name.toLowerCase() == currencyId.toLowerCase()) {
        selectedCrypto = crypto;
        break; // Exit loop once the match is found
      }
    }

    // Check if a currency was found
    if (selectedCrypto != null) {
      emit(CryptoPricesLoaded([selectedCrypto])); // Emit the selected cryptocurrency data
    } else {
      emit(CryptoPricesError('Currency not found'));
    }
  } catch (e) {
    emit(CryptoPricesError('Failed to fetch data: $e'));
  }
}

}
