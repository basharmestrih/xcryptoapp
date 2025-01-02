import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';
import 'package:url_launcher/url_launcher.dart';

class FavePage extends StatefulWidget {
  const FavePage({Key? key}) : super(key: key);

  @override
  _FavePageState createState() => _FavePageState();
}

class _FavePageState extends State<FavePage> {
  late List<VideoPlayerController> _controllers;

  final List<String> videoUrls = [
    'https://www.learningcontainer.com/wp-content/uploads/2020/05/sample-mp4-file.mp4',
    'https://www.learningcontainer.com/wp-content/uploads/2020/05/sample-mp4-file.mp4',
    'https://www.learningcontainer.com/wp-content/uploads/2020/05/sample-mp4-file.mp4',
    'https://www.learningcontainer.com/wp-content/uploads/2020/05/sample-mp4-file.mp4',
    'https://www.learningcontainer.com/wp-content/uploads/2020/05/sample-mp4-file.mp4',
  ];

  final List<String> courseNames = [
    'Trading Butterfly Spreads for Income',
    'How To Day Trade Crypto CFDs For A Living',
    'Cryptocurrency Trading Strategies',
    'The Complete Cryptocurrency Investment Course',
  ];

  final List<String> courseLinks = [
    'https://www.udemy.com/course/the-complete-cryptocurrency-course-more-than-5-courses-in-1/',
    'https://www.udemy.com/course/how-to-day-trade-crypto-cfds-for-a-living/',
    'https://example.com/course3',
    'https://www.udemy.com/course/complete-cryptocurrency-investing-course-passive-active/?couponCode=LETSLEARNNOW',
  ];

  @override
  void initState() {
    super.initState();
    _controllers = videoUrls
        .map((url) => VideoPlayerController.network(url)..initialize())
        .toList();
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
    // Copy link function
  void _copyLink(String link) {
    Clipboard.setData(ClipboardData(text: link)).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Link copied to clipboard!')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
      child: Column(
        children: [
           Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Crypto videos for you',
                 style: GoogleFonts.balooDa2(fontSize: 24.0,fontWeight: FontWeight.bold,color: Colors.yellow,),
              ),
            ],
          ),
          SizedBox(height: screenHeight * 0.002),
          SizedBox(
            height: screenHeight * 0.3,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: videoUrls.length,
              itemBuilder: (context, index) {
                final controller = _controllers[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          content: AspectRatio(
                            aspectRatio: controller.value.aspectRatio,
                            child: VideoPlayer(controller),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                controller.pause();
                              },
                              child: const Text('Close'),
                            ),
                          ],
                        ),
                      );
                      controller.play();
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 4,
                      child: Container(
                        width: screenWidth * 0.7,
                        height: 200,
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Expanded(
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: AspectRatio(
                                      aspectRatio: controller.value.isInitialized
                                          ? controller.value.aspectRatio
                                          : 16 / 9,
                                      child: VideoPlayer(controller),
                                    ),
                                  ),
                                  const Center(
                                    child: Icon(
                                      Icons.play_circle_filled,
                                      size: 50,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'Video ${index + 1}',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
           Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Courses picked for you',
                style: GoogleFonts.balooDa2(fontSize: 24.0,fontWeight: FontWeight.bold,color: Colors.yellow,),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: courseNames.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 13.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 54, 56, 53),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            courseNames[index],
                             style: GoogleFonts.balooDa2(fontSize: 15.0,fontWeight: FontWeight.bold,color: Colors.yellow,
                                ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 5),
                      IconButton(
                        icon: const Icon(Icons.copy, color: Colors.grey),
                        onPressed: () {
                          _copyLink(courseLinks[index]);
                        },
                      ),
                      const SizedBox(width: 10),
                      IconButton(
                        icon: const Icon(Icons.language, color: Colors.blue),
                        onPressed: () {
                          _launchURL(courseLinks[index]);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
