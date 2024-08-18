import 'package:flutter/material.dart';
import 'package:useful_services_frontend/pages/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Useful Services',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lime[700]!)
            .copyWith(surface: Colors.white),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
