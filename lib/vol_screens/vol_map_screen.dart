import 'package:flutter/material.dart';
import '../vol_widgets/vol_topbar.dart';

class VolMyRoutesScreen extends StatelessWidget {
  const VolMyRoutesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const VolTopbar(),
      body: const SizedBox.shrink(), 
    );
  }
}