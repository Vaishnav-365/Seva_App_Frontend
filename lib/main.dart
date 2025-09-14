import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/auth_service.dart';
import 'state/app_state.dart';
import 'app_router.dart';
import 'package:seva_frontend/screens/attendance_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Replace FakeAuthService
  final authService = FakeAuthService();

  runApp(
    MultiProvider(
      providers: [
        Provider<AuthService>.value(value: authService),
        ChangeNotifierProvider<AppState>(create: (_) => AppState()),
        ChangeNotifierProvider(create: (_) => AttendanceState()),
      ],
      child: const SevaApp(),
    ),
  );
}

class SevaApp extends StatelessWidget {
  const SevaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Amma\'s Birthday Seva App',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: Colors.white,
      ),
      initialRoute: AppRoutes.login,
      onGenerateRoute: AppRouter.generateRoute,
      debugShowCheckedModeBanner: false,
    );
  }
}
