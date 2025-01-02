import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:flutter_application_1/features/Fetching_Currencies/application/Fething_Crypto_Cubit.dart';
import 'package:flutter_application_1/features/Fetching_Currencies/application/Fetching_Crypto_State.dart';
import 'package:flutter_application_1/features/Fetching_Currencies/data/Fetching_Crypto_Repo.dart';
import 'package:flutter_application_1/features/Fetching_Currencies/data/Fetching_Crypto_Web_Sers.dart';

class Xcrypto extends StatefulWidget {
  final String currencyId; // Pass the currency ID to fetch data

  const Xcrypto({Key? key, required this.currencyId}) : super(key: key);

  @override
  _XcryptoState createState() => _XcryptoState();
}

class _XcryptoState extends State<Xcrypto> {
  @override
  void initState() {
    super.initState();
    // Perform any additional setup if needed
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title:  Text(
          'Crypto Details',
          style: GoogleFonts.balooDa2(
                fontWeight: FontWeight.bold,
                color: Colors.yellow,
                fontSize: 24
              ), 
        ),
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,color: Colors.yellow,),
          onPressed: () {
            Navigator.of(context).pop(); // Navigate back when pressed
          },
        ),
      ),
      floatingActionButton: Column(
  mainAxisAlignment: MainAxisAlignment.end,
  children: [
    // First FloatingActionButton for adding to favorites
    FloatingActionButton(
      onPressed: () async {
        final box = Hive.box('mycurrencies');
        if (box.values.contains(widget.currencyId)) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Currency is already in your favorites!'),
            ),
          );
        } else {
          await box.add(widget.currencyId);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Currency added to favorites!'),
            ),
          );
        }

        // Debugging: Print all stored values
        for (var value in box.values) {
          print('Value: $value');
        }
      },
      backgroundColor: Color.fromARGB(255, 54, 56, 53),
      child: const Icon(Icons.favorite, color: Colors.yellow),
    ),
    SizedBox(height: 16), // Spacing between buttons

    // Second FloatingActionButton for removing from favorites
    FloatingActionButton(
      onPressed: () async {
        final box = Hive.box('mycurrencies'); // Access the Hive box

        // Find the key of the currencyId
        final keyToDelete = box.keys.firstWhere(
          (key) => box.get(key) == widget.currencyId,
          orElse: () => null,
        );

        if (keyToDelete != null) {
          await box.delete(keyToDelete); // Delete the key
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Currency removed from favorites!'),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Currency not found in favorites!'),
            ),
          );
        }

        // Debug: Print all remaining Hive box data
        for (var key in box.keys) {
          print('Key: $key, Value: ${box.get(key)}');
        }
      },
      backgroundColor: Color.fromARGB(255, 54, 56, 53),
      child: const Icon(Icons.delete, color: Colors.yellow),
    ),
  ],
),


      

      body: BlocProvider(
        create: (context) => CryptoPricesCubit(CryptoPricesRepository(CryptoPricesWeb()))
          ..fetchCryptoData(widget.currencyId),
        child: BlocBuilder<CryptoPricesCubit, CryptoPricesState>(
          builder: (context, state) {
            if (state is CryptoPricesLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is CryptoPricesError) {
              return Center(
                child: Text(
                  state.message,
                  style: const TextStyle(color: Colors.red),
                ),
              );
            } else if (state is CryptoPricesLoaded) {
              final crypto = state.cryptoPrice.first; // Use the first (and only) item

              return Column(
                children: [
                  // Image at the top
                  Container(
                    height: screenHeight * 0.2,
                    width: screenWidth,
                    color: const Color.fromARGB(255, 0, 0, 0),
                    child: Image.network(
                      crypto.imageUrl,
                      fit: BoxFit.contain,
                    ),
                  ),
                   SizedBox(height: screenHeight * 0.0002),

                  // Title in the center
                  Center(
                    child: Text(
                      crypto.name,
                      style: GoogleFonts.balooDa2(
                fontWeight: FontWeight.bold,
                color: Colors.yellow,
                fontSize: 27
              ), 
                    ),
                  ),
                  
                   SizedBox(height: screenHeight * 0.012),

                  //row of 4 buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.calculate, color: Colors.grey, size: 40),
                        onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (context) => CalculatorSheet(price: crypto.price),
                        );
                      },
                    ),
                       SizedBox(width: screenWidth * 0.011),
                      IconButton(
                        icon: const Icon(Icons.add_chart, color: Colors.grey, size: 40),
                        onPressed: () {},
                      ),
                       SizedBox(width: screenWidth * 0.011),
                      IconButton(
                        icon: const Icon(Icons.document_scanner, color: Colors.grey, size: 40),
                        onPressed: () async {
                          

                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.mail, color: Colors.grey, size: 40),
                          onPressed: () async {
                          
                        },
                      ),
                    ],
                  ),
                   SizedBox(height: screenHeight * 0.01) ,
                  // row for additonal data
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Data provided by: ',
                              style: GoogleFonts.balooDa2(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
                fontSize: 14
              ), 
                            ),
                             TextSpan(
                              text: 'CoinBase',
                             style: GoogleFonts.balooDa2(
                fontWeight: FontWeight.bold,
                color: Colors.blue,
                fontSize: 14
              ), 
                            ),
                          ],
                        ),
                      ),
                       Text(
                        'Last updated by: 22:43',
                        style: GoogleFonts.balooDa2(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
                fontSize: 14
              ), 
                      ),
                    ],
                  ),
                   SizedBox(height: screenHeight * 0.02),
                  Expanded(
                    child: ListView(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildCard('Price', '\$${crypto.price.toStringAsFixed(2)}',screenHeight,screenWidth),
                            _buildCard('Rank', '${crypto.market_cap_rank}',screenHeight,screenWidth),
                          ],
                        ),
                         SizedBox(height: screenHeight * 0.01),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildCard('High 24h', '\$${crypto.high_24h.toStringAsFixed(2)}',screenHeight,screenWidth),
                            _buildCard('Low 24h', '\$${crypto.low_24h.toStringAsFixed(2)}',screenHeight,screenWidth),
                          ],
                        ),
                         SizedBox(height: screenHeight * 0.01),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildCard('Change 24h', '${crypto.changePercentage.toStringAsFixed(2)}%',screenHeight,screenWidth),
                            _buildCard('Volume', '\$${crypto.price.toStringAsFixed(2)}',screenHeight, screenWidth),
                          ],
                        ),
                      ],
                    ),
                    
                    
                  ),
                  
                ],
              );
            } else {
              return const Center(child: Text('Unexpected state'));
            }
          },
        ),
      ),
    );
  }

  Widget _buildCard(String title, String value, double screenHeight ,double screenWidth ) {
    return SizedBox(
      height: screenHeight * 0.1,
      width: screenWidth * 0.44,
      child: Card(
        margin: const EdgeInsets.all(4.0),
        color: const Color.fromARGB(255, 54, 56, 53),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
               style: GoogleFonts.balooDa2(
                fontWeight: FontWeight.bold,
                color: Colors.yellow,
                fontSize: 17
              ), 
                textAlign: TextAlign.center,
              ),
               SizedBox(height: screenHeight * 0.003),
              Text(
                value,
                style: GoogleFonts.balooDa2(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
                fontSize: 10
              ), 
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}



class CalculatorSheet extends StatefulWidget {
  final double price; // Price of the cryptocurrency

  const CalculatorSheet({Key? key, required this.price}) : super(key: key);

  @override
  State<CalculatorSheet> createState() => _CalculatorSheetState();
}

class _CalculatorSheetState extends State<CalculatorSheet> {
  final TextEditingController cryptoToUsdCryptoController = TextEditingController();
  final TextEditingController cryptoToUsdUsdController = TextEditingController();
  final TextEditingController usdToCryptoUsdController = TextEditingController();
  final TextEditingController usdToCryptoCryptoController = TextEditingController();

  void calculateConversion(bool fromCryptoToUSD) {
    if (fromCryptoToUSD) {
      // Convert crypto to USD
      final cryptoAmount = double.tryParse(cryptoToUsdCryptoController.text) ?? 0;
      cryptoToUsdUsdController.text = (cryptoAmount * widget.price).toStringAsFixed(2);
    } else {
      // Convert USD to crypto
      final usdAmount = double.tryParse(usdToCryptoUsdController.text) ?? 0;
      usdToCryptoCryptoController.text = (usdAmount / widget.price).toStringAsFixed(6);
    }
  }

  @override
  void dispose() {
    // Dispose controllers to free memory
    cryptoToUsdCryptoController.dispose();
    cryptoToUsdUsdController.dispose();
    usdToCryptoUsdController.dispose();
    usdToCryptoCryptoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      height: 500,
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 54, 56, 53),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
           Text(
            'Crypto Converter',
           style: GoogleFonts.balooDa2(
                fontWeight: FontWeight.bold,
                color: Colors.yellow,
                fontSize: 20
              ), 
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Price now: ${widget.price.toStringAsFixed(2)} \$',
               style: GoogleFonts.balooDa2(
                fontWeight: FontWeight.bold,
                color: Colors.yellow,
                fontSize: 20
              ), 
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: cryptoToUsdCryptoController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Crypto',
                    labelStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.yellow),
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.arrow_forward, color: Colors.yellow),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: cryptoToUsdUsdController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'USD',
                    labelStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.yellow),
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () => calculateConversion(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.yellow,
            ),
            child:  Text(
              'Convert Crypto to USD',
             style: GoogleFonts.balooDa2(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ), 
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: usdToCryptoUsdController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'USD',
                    labelStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.yellow),
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.arrow_forward, color: Colors.yellow),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: usdToCryptoCryptoController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Crypto',
                    labelStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.yellow),
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () => calculateConversion(false),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.yellow,
            ),
            child:  Text(
              'Convert USD to Crypto',
             style: GoogleFonts.balooDa2(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ), 
            ),
          ),
        ],
      ),
    );
  }
}
