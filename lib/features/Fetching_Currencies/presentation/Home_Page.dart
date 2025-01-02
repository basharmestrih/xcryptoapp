import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/Fetching_Currencies/application/Fetching_Crypto_State.dart';
import 'package:flutter_application_1/features/Fetching_Currencies/application/Fething_Crypto_Cubit.dart';
import 'package:flutter_application_1/features/Fetching_Currencies/data/Fetching_Crypto_Repo.dart';
import 'package:flutter_application_1/features/Fetching_Currencies/data/Fetching_Crypto_Web_Sers.dart';
import 'package:flutter_application_1/features/Fetching_Currencies/domain/Fetching_Crypto_Model.dart';
import 'package:flutter_application_1/features/Fetching_Currencies/presentation/All_Currenices_Page.dart';
import 'package:flutter_application_1/features/Fetching_Currencies/presentation/Crypto_info.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';

class HomePage extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<HomePage> {
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
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Text(
              "My Portfolio",
              style: GoogleFonts.balooDa2(
                fontWeight: FontWeight.bold,
                color: Colors.yellow,
                fontSize: 24
              ),                  
            ),
            SizedBox(height: screenHeight * 0.01),
            SizedBox(
              height: screenHeight * 0.3, // Adjust based on the card size
              child: BlocBuilder<CryptoPricesCubit, CryptoPricesState>(
                builder: (context, state) {
                  if (state is CryptoPricesLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is CryptoPricesError) {
                    return Center(child: Text(state.message));
                  } else if (state is CryptoPricesLoaded) {
                    return SizedBox(
                    height: screenHeight * 0.4, // Set the desired height for the ListView
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: state.cryptoPrice.length,
                      itemBuilder: (context, index) {
                        return _buildCryptoCard(state.cryptoPrice[index],screenHeight , screenWidth);
                      },
                    ),
                  );
                  } else {
                    return const Center(child: Text('No Data Available'));
                  }
                },
              ),
            ),
             SizedBox(height: screenHeight * 0.01),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                 Text(
                  "Top Currencies",
                  style: GoogleFonts.balooDa2(
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.yellow,
                                ),
                  
                ),
                
                GestureDetector(
                  onTap: () {
                    // Navigate to the new page when tapped
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AllCurrenciesPage()),
                    );
                  },
                  child:  Text(
                    "See All",
                    style: GoogleFonts.balooDa2(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                  ),
                ),
              ],
            ),

             SizedBox(height: screenHeight * 0.01),
            Expanded(
              child: BlocBuilder<CryptoPricesCubit, CryptoPricesState>(
                builder: (context, state) {
                  if (state is CryptoPricesLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is CryptoPricesError) {
                    return Center(child: Text(state.message));
                  } else if (state is CryptoPricesLoaded) {
                    final limitedList = state.cryptoPrice.take(7).toList();
                    return ListView.builder(
                      itemCount: limitedList.length,
                      itemBuilder: (context, index) {
                        return _buildVerticalItem(state.cryptoPrice[index], screenHeight, screenWidth);
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
    );
  }

Widget _buildCryptoCard(CryptoPrices crypto, screenHeight, screenWidth) {
  
    final box = Hive.box('mycurrencies'); // Access the Hive box
bool existsInHive = box.values.contains(crypto.id);

if (!existsInHive) {
  return const SizedBox.shrink(); // Returns an invisible widget
}

  return SizedBox(
    height: screenHeight * 0.25,
    child: Container(
      width: screenWidth * 0.6,
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 45, 45, 45),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: screenWidth * 0.89,
              height: screenHeight * 0.2,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: const Color.fromARGB(255, 0, 0, 0),
              ),
              alignment: Alignment.center,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Container(
                  width: double.infinity,
                  height: screenHeight * 0.17,
                  child: Image.network(
                    crypto.imageUrl,
                    //fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  crypto.name,
                  style: GoogleFonts.balooDa2(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.yellow,
                                ),
                ),
              ],
            ),
             SizedBox(height: screenHeight * 0.008),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "\$${crypto.price.toStringAsFixed(2)}",
                  style: GoogleFonts.balooDa2(
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                ),
                Text(
                  "${crypto.changePercentage > 0 ? '+' : ''}${crypto.changePercentage.toStringAsFixed(2)}%",
                  style: TextStyle(
                    color: crypto.changePercentage > 0 ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ],
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
