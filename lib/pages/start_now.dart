import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/Fetching_Articles/presentation/Fetching_Articles_Page.dart';
import '../features/Fetching_Currencies/presentation/Home_Page.dart'; // Import your HomePage
import '../features/For_You/presentation/For_You_page.dart';
import 'package:google_fonts/google_fonts.dart';

class StartNowPage extends StatefulWidget {
  @override
  _StartNowPageState createState() => _StartNowPageState();
}

class _StartNowPageState extends State<StartNowPage> {
  int _selectedIndex = 0;

  // List of pages to display
  final List<Widget> _pages = [
    HomePage(),
    ArticlesPage(), // Replace with your actual ArticlesPage widget
    FavePage(), // Replace with your actual SearchPage widget
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Xcrypto',
        style: GoogleFonts.archivoBlack(
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
            color: Colors.yellow,
          ),
        
                    
                  ),),
        
      
      body: _pages[_selectedIndex], // Display the selected page
      drawer: Drawer(
      backgroundColor: Colors.black,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 0, 0, 0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Xcrypto',
                  style: GoogleFonts.balooDa2(
                    fontWeight: FontWeight.bold,
                    color: Colors.yellow,
                    fontSize:24,
                  ),
                ),
                //SizedBox(height: ),
                // Network Image
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 112,
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: const DecorationImage(
                          image: NetworkImage('https://img.icons8.com/?size=100&id=ZuLBkjDczTqY&format=png&color=000000'), // Replace with your image URL
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          ListTile(
            title: Text(
              'Live Prices',
              style: GoogleFonts.balooDa2(
                fontWeight: FontWeight.bold,
                color: Colors.yellow,
              ),
            ),
            onTap: () {
              // Handle item 1 tap
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => StartNowPage()),
              );
            },
          ),
          ListTile(
            title: Text(
              'Latest News',
              style: GoogleFonts.balooDa2(
                fontWeight: FontWeight.bold,
                color: Colors.yellow,
              ),
            ),
            onTap: () {
              // Handle item 2 tap
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => StartNowPage()),
              );
            },
          ),
          ListTile(
            title: Text(
              'For you',
              style: GoogleFonts.balooDa2(
                fontWeight: FontWeight.bold,
                color: Colors.yellow,
              ),
            ),
            onTap: () {
              // Handle item 3 tap
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => StartNowPage()),
              );
            },
          ),
          ListTile(
            title: Text(
              'Contact Support',
              style: GoogleFonts.balooDa2(
                fontWeight: FontWeight.bold,
                color: Colors.yellow,
              ),
            ),
            onTap: () {
              // Handle item 3 tap
              Navigator.pop(context); // Close the drawer
            },
          ),
          ListTile(
            title: Text(
              'Logout',
              style: GoogleFonts.balooDa2(
                fontWeight: FontWeight.bold,
                color: Colors.yellow,
              ),
            ),
            onTap: () {
              // Handle item 3 tap
              Navigator.pop(context); // Close the drawer
            },
          ),
        ],
      ),
    ),

      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Live Prices',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.article),
            label: 'Latest News',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'For You',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor:  Color.fromARGB(255, 230, 219, 2),
        onTap: _onItemTapped,
      ),
    );
  }
}
