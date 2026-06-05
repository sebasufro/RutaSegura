import 'package:flutter/material.dart';
import '../vol_widgets/vol_navbar.dart';

class VolConfigScreen extends StatelessWidget {
  const VolConfigScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuraciones'),
      ),
      body: const SizedBox.shrink(), 
    );
  }
}