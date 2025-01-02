import 'dart:async'; // For Timer
import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/Fetching_Articles/application/Fetching_Articles_Cubit.dart';
import 'package:flutter_application_1/features/Fetching_Articles/application/Fetching_Articles_State.dart';
import 'package:flutter_application_1/features/Fetching_Articles/data/Fetching_Articles_Repo.dart';
import 'package:flutter_application_1/features/Fetching_Articles/data/Fetching_Articles_Web_Sers.dart';
import 'package:flutter_application_1/features/Fetching_Currencies/data/Fetching_Crypto_Web_Sers.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart'; // For Clipboard
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';





class ArticlesPage extends StatefulWidget {
  @override
  _ArticlesPageState createState() => _ArticlesPageState();
}

class _ArticlesPageState extends State<ArticlesPage> {
  Timer? _timer;
   List<Color> _iconColors = []; // List to hold colors for each heart icon


  // Toggle heart button function
  void _toggleHeart(int index) {
    setState(() {
      // Change color for the specific index
      _iconColors[index] = (_iconColors[index] == Colors.grey) ? Colors.yellow : Colors.grey;
    });
  }
  // Copy link function
  void _copyLink(String link) {
    Clipboard.setData(ClipboardData(text: link)).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Link copied to clipboard!')),
      );
    });
  }
  // Function to launch URL in browser
  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication); // Open in external browser
    } else {
      throw 'Could not launch $url';
    }
  }




  @override
  void initState() {
    super.initState();
    // Initialize the icon colors list with grey color for each article
    _iconColors = List<Color>.filled(100, Colors.grey); // Assuming a max of 100 articles
  }



  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return BlocProvider(
      create: (context) => ArticlesCubit(ArticlesRepository(NewsApiService()))..fetchoArticles(),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: BlocBuilder<ArticlesCubit, ArticlesState>(
          builder: (context, state) {
            if (state is ArticlesLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ArticlesLoaded) {
              return ListView.builder(
                itemCount: state.articles.length,
                itemBuilder: (context, index) {
                  final article = state.articles[index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 10, top: 10),
                    child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // The Card
                      SizedBox(
                        width: screenWidth * 0.99,
                        child: Card(
                          color: const Color.fromARGB(255, 54, 56, 53),
                          child: Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Add the network image container here
                                Container(
                                  width: double.infinity,
                                  height: screenHeight * 0.25, // Adjust height as needed
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    image: DecorationImage(
                                      image: NetworkImage(article.image),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                SizedBox(height: screenHeight * 0.008),
                                Text(
                                  article.title ?? 'No content available',
                                  style: GoogleFonts.balooDa2(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.yellow,
                                ),
                                ),
                                SizedBox(height: screenHeight * 0.008),
                                Text(
                                  article.content ?? 'No details available.',
                                  style: GoogleFonts.balooDa2(
                                  fontSize: 13.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.001),

                      // The Row for Icons Inside Containers
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          // like button
                          Container(
                            width: screenWidth * 0.178,
                            height: screenHeight * 0.05,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 54, 56, 53),
                              borderRadius: BorderRadius.circular(30), // Rounded corners
                            ),
                            child: IconButton(
                              icon: Icon(Icons.favorite, color: _iconColors[index]), // Use the color from the list),
                              onPressed: () {
                                _toggleHeart(index);
                              },
                            ),
                          ),
                          SizedBox(width: screenWidth * 0.066),
                          // copy button
                          Container(
                            width: screenWidth * 0.178,
                            height: screenHeight * 0.05,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 54, 56, 53),
                              borderRadius: BorderRadius.circular(30), // Rounded corners
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.copy, color: Colors.yellow),
                              onPressed: () {
                                _copyLink(article.link);
                              },
                            ),
                          ),
                          SizedBox(width: screenWidth * 0.066),
                          // share button
                          Container(
                            width: screenWidth * 0.178,
                            height: screenHeight * 0.05,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 54, 56, 53),
                              borderRadius: BorderRadius.circular(30), // Rounded corners
                            ),
                            child: IconButton(
                              icon: Icon(Icons.share, color: Colors.yellow),
                              onPressed: () {
                                Share.share(article.link);
                              },
                            ),
                          ),
                          SizedBox(width: screenWidth * 0.066),
                          Container(
                            width: screenWidth * 0.178,
                            height: screenHeight * 0.05,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 54, 56, 53),
                              borderRadius: BorderRadius.circular(30), // Rounded corners
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.language, color: Colors.yellow),
                              onPressed: () {
                                _launchURL(article.link);
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      const Divider(
                        color: Colors.grey,
                        thickness: 5,
                        indent: 0,
                        endIndent: 0,
                      ),
                    ],
                  ),

                  );
                },
              );
            } else if (state is ArticlesError) {
              return Center(child: Text('Error: ${state.message}'));
            } else {
              return const Center(child: Text('No articles available.'));
            }
          },
        ),
      ),
    );
  }
}
