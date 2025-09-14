import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seva_frontend/screens/attendance_screen.dart';
import '../widgets/top_banner.dart';
import '../widgets/category_card.dart';
import '../widgets/bottom_nav.dart';
import '../models/seva_model.dart';
import '../state/app_state.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static final List<SevaCategory> categories = [
    SevaCategory(id: 'help', title: 'May I Help You'),
    SevaCategory(id: 'volcare', title: 'Volunteer Care'),
    SevaCategory(id: 'plate', title: 'Plate Washing'),
    SevaCategory(id: 'venue', title: 'Venue Maintenance'),
    SevaCategory(id: 'special', title: 'Special Invitees'),
    SevaCategory(id: 'press', title: 'Press & Media'),
    SevaCategory(id: 'cultural', title: 'Cultural'),
  ];

  void _onCategoryTap(BuildContext context, SevaCategory cat) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Open ${cat.title}')));
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final user = appState.user;

    return ChangeNotifierProvider(
      create: (_) => AttendanceState(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Seva Home'),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                // sign out via AuthService and navigate to login
                final auth = Provider.of(context, listen:false);
                // ignore: avoid_dynamic_calls
                auth.signOut();
                Navigator.pushReplacementNamed(context, '/');
              },
            )
          ],
        ),
        bottomNavigationBar: const AppBottomNav(currentIndex: 0),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TopBanner(
                  title: 'Welcome ${user?.name ?? 'Volunteer'}',
                  subtitle: 'Choose your seva and check-in',
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: GridView.builder(
                    itemCount: categories.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 3/2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemBuilder: (context, i) {
                      final cat = categories[i];
                      return CategoryCard(category: cat, onTap: () => _onCategoryTap(context, cat));
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
