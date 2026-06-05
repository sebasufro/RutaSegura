import 'package:flutter/material.dart';
import '../vol_widgets/vol_topbar.dart';

class VolMyDirectionsScreen extends StatelessWidget {
  const VolMyDirectionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const VolTopbar(),
      body: const SizedBox.shrink(), 
    );
  }
}