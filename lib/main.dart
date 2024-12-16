import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'screens/register_screen.dart';
import 'screens/logo_screen.dart';
import 'services/auth_service.dart';
import 'services/localization_service.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthService()),
        ChangeNotifierProvider(create: (context) => LocalizationService()),
      ],
      child: const HelioApp(),
    ),
  );
}

class HelioApp extends StatelessWidget {
  const HelioApp({super.key});

  @override
  Widget build(BuildContext context) {
    // final localizationService = Provider.of<LocalizationService>(context);
    
    return MaterialApp(
      title: 'Helio Health App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => Consumer<AuthService>(
          builder: (context, authService, child) {
            if (authService.isInitializing) {
              return const LogoScreen();
            } else {
              return const HomeScreen();
            }
          },
        ),
        '/register': (context) => const RegisterScreen(),
      },
    );
  }
}

