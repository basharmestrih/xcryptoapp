import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/Fetching_Currencies/application/Fething_Crypto_Cubit.dart';
import 'package:flutter_application_1/features/Fetching_Currencies/domain/Fetching_Crypto_Model.dart';
import 'package:flutter_application_1/features/Fetching_Currencies/data/Fetching_Crypto_Web_Sers.dart';
import 'package:flutter_application_1/features/Fetching_Currencies/presentation/Crypto_info.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_1/features/Fetching_Currencies/application/Fetching_Crypto_State.dart';
import 'package:flutter_application_1/features/Fetching_Currencies/data/Fetching_Crypto_Repo.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';

class AllCurrenciesPage extends StatefulWidget {
  @override
  _AllCurrenciesPageState createState() => _AllCurrenciesPageState();
}

class _AllCurrenciesPageState extends State<AllCurrenciesPage> {
  @override
  void initState() {
    super.initState();
    // Trigger data fetch when the widget is initialized
  }

  @override
  Widget build(BuildContext context) {
    //media query def
    final size = MediaQuery.of(context).size;
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return BlocProvider(
      create: (context) => CryptoPricesCubit(CryptoPricesRepository(CryptoPricesWeb()))..fetchFinalData(),
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
        title: const Text(
          'All Currencies',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.yellow,
          ),
        ),
        backgroundColor: Colors.black,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.yellow),
            onPressed: () {
              Navigator.of(context).pop(); // Navigate back when pressed
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search, color: Colors.yellow),
              onPressed: () {
                // Add your search functionality here
              },
            ),
          ],
        ),

        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              const SizedBox(height: 10),
              Expanded(
                child: BlocBuilder<CryptoPricesCubit, CryptoPricesState>(
                  builder: (context, state) {
                    if (state is CryptoPricesLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is CryptoPricesError) {
                      return Center(child: Text(state.message));
                    } else if (state is CryptoPricesLoaded) {
                      final limitedList = state.cryptoPrice.take(100).toList();
                      return ListView.builder(
                        itemCount: limitedList.length,
                        itemBuilder: (context, index) {
                          return _buildVerticalItem(limitedList[index], screenHeight, screenWidth);
                        },
                      );
                    } else {
                      return const Center(child: Text('No Data Available'));
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVerticalItem(CryptoPrices crypto,screenHeight, screenWidth) {
    return GestureDetector(
      onTap: () {
        // Navigate to Xcrypto with the selected currency's ID
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Xcrypto(currencyId: crypto.id),
          ),
        );
        print(crypto.id);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 54, 56, 53),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                crypto.imageUrl,
                width: screenWidth* 0.222,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    crypto.name,
                   style: GoogleFonts.balooDa2(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    crypto.symbol.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color.fromARGB(255, 230, 219, 2),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "\$${crypto.price.toStringAsFixed(2)}",
                  style: GoogleFonts.balooDa2(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                ),
                const SizedBox(height: 4),
                Text(
                  "${crypto.changePercentage > 0 ? '+' : ''}${crypto.changePercentage.toStringAsFixed(2)}%",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color:
                        crypto.changePercentage > 0 ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
