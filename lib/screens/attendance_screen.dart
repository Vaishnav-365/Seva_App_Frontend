import 'package:flutter/material.dart';
import '../widgets/bottom_nav.dart';

class AttendanceScreen extends StatelessWidget {
  const AttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Attendance')),
      bottomNavigationBar: const AppBottomNav(currentIndex: 2),
      body: const Center(child: Text('Attendance page.')),
    );
  }
}
