import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/attendance_screen.dart';
import 'screens/map_screen.dart';

class AppRoutes {
  static const login = '/';
  static const home = '/home';
  static const attendance = '/attendance';
  static const map = '/map';
}

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case AppRoutes.attendance:
        return MaterialPageRoute(builder: (_) => const AttendanceScreen());
      case AppRoutes.map:
        return MaterialPageRoute(builder: (_) => const MapScreen());
      case AppRoutes.login:
      default:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
    }
  }
}
