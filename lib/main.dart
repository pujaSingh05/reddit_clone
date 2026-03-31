import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/screens/login_screen.dart';
import 'package:reddit_clone/theme/palllete.dart/pallete.dart';
import 'firebase_options.dart';


void main() async {
  // Ensure Firebase has been initialised before runApp
  WidgetsFlutterBinding.ensureInitialized();  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Reddit Clone',
      theme: Pallete.darkModeAppTheme,
      // darkTheme: Pallete.darkModeAppTheme,
      home: LoginScreen()
    );
  }
}

