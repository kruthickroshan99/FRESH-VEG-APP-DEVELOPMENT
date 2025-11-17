import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login.dart';
import 'home.dart';
import 'firebase_options.dart';
import 'services/data_seeder.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Seed products on first run
  await DataSeeder.seedProducts();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Fresh Veg",
      theme: ThemeData(
        primarySwatch: Colors.green,
        textTheme: GoogleFonts.hennyPennyTextTheme(
          Theme.of(context).textTheme,
        ),
        useMaterial3: true,
      ),
      // Check if user is already logged in
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          
          if (snapshot.hasData) {
            // User is logged in, go to home page
            return const HomePage();
          } else {
            // User is not logged in, go to login page
            return const LoginScreen();
          }
        },
      ),
    );
  }
}