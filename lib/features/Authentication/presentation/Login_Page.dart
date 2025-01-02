import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/features/Fetching_Currencies/presentation/Crypto_info.dart';
import 'package:flutter_application_1/pages/start_now.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../Fetching_Currencies/presentation/Home_Page.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> login(BuildContext context) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      // Navigate to StartNowPage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => StartNowPage()),
      );
    } catch (e) {
      print("Login failed: $e");
    }
  }

  void showSignUpDialog(BuildContext context) {
    TextEditingController signUpEmailController = TextEditingController();
    TextEditingController signUpPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Sign Up"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: signUpEmailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              TextField(
                controller: signUpPasswordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                try {
                  await FirebaseAuth.instance.createUserWithEmailAndPassword(
                    email: signUpEmailController.text,
                    password: signUpPasswordController.text,
                  );
                  Navigator.pop(context);
                  showCongratsDialog(context);
                } catch (e) {
                  print('Sign Up failed: $e');
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 237, 8, 103),
                foregroundColor: Colors.white,
              ),
              child: const Text('Create Account'),
            ),
          ],
        );
      },
    );
  }

  void showCongratsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Congrats!'),
          backgroundColor: const Color.fromARGB(255, 0, 0, 0),
          content: const Text('Now you are one of us! Hit Go to start your journey.'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => StartNowPage()),
                );
              },
              child: const Text('Go'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 237, 8, 103),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    print(size);
    print(width);
    print(height);

    return Scaffold(
      backgroundColor: const Color.fromARGB(240, 14, 13, 13),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: width * 0.05, // 5% of screen width
            vertical:   width * 0.3, 
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Xcrypto',
                style: GoogleFonts.rubikMonoOne(
                  fontSize: width * 0.09, // 9% of screen width
                  fontWeight: FontWeight.bold,
                  color: Colors.yellow,
                ),
              ),
              SizedBox(height: height * 0.01),
              Text(
                'your crypto home',
                style: GoogleFonts.rubikMonoOne(
                  fontSize: width * 0.06, // 6% of screen width
                  fontWeight: FontWeight.bold,
                  color: Colors.yellow,
                ),
              ),
              SizedBox(height: height * 0.07),
        
              // Image container
              Container(
                width: width * 0.4, // 30% of screen width
                height: width * 0.4, // Maintain square shape
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage('https://img.icons8.com/?size=100&id=ZuLBkjDczTqY&format=png&color=000000'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: height * 0.02),
        
              // Email TextField
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(color: Colors.yellow),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.yellow),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.yellow),
                  ),
                ),
                style: const TextStyle(color: Colors.yellow),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: height * 0.02),
        
              // Password TextField
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(color: Colors.yellow),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.yellow),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.yellow),
                  ),
                ),
                style: const TextStyle(color: Colors.yellow),
                obscureText: true,
              ),
              SizedBox(height: height * 0.06),
        
              // Buttons
              buildButton(context, width, 'Login', () => login(context)),
              SizedBox(height: height * 0.01),
              buildButton(context, width, 'Sign Up', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => StartNowPage()),
                );
              }),
              SizedBox(height: height * 0.01),
              buildButton(context, width, 'Guest', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => StartNowPage()),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildButton(BuildContext context, double width, String text, VoidCallback onPressed) {
    return SizedBox(
      width: width * 0.4, // 40% of screen width
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(164, 54, 56, 53),
          minimumSize: Size(double.infinity, 50), // Height fixed
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.yellow),
        ),
      ),
    );
  }
}
