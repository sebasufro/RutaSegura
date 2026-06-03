import 'package:flutter/material.dart';
import 'vol_widgets/vol_navbar.dart';

void main() => runApp(const RutaSeguraApp());

class RutaSeguraApp extends StatelessWidget {
  const RutaSeguraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ruta Segura',
      theme: ThemeData(
        primaryColor: const Color(0xFF1E3A8A),
        scaffoldBackgroundColor: Colors.grey[50],
      ),
      home: const VolNavbar(),
    );
  }
}