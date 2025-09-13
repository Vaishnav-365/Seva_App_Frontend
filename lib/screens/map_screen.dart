import 'package:flutter/material.dart';
import '../widgets/bottom_nav.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Venue Map')),
      bottomNavigationBar: const AppBottomNav(currentIndex: 1),
      body: const Center(
        child: Text('Map placeholder.'),
      ),
    );
  }
}
