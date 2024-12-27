import 'package:flutter/material.dart';
import 'package:gorins/presentation/auth/views/view.dart';
import 'package:gorins/presentation/home/views/view.dart';

/// Centralized route names and generation logic.
class Routes {
  /// Route names
  static const String login = '/login';
  static const String signup = '/signup';
  static const String home = '/home';

  /// Generate routes dynamically
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(
          builder: (_) =>   const LoginScreen(),
        );
        
      case signup:
        return MaterialPageRoute(builder: (_) => const SignupScreen());

      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
    }
    return null;
  }
}
