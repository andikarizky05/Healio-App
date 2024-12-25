import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/localization_service.dart';
import 'health_info_screen.dart';
import 'nearest_facilities_screen.dart';
import 'emergency_services_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final List<Widget> _screens = [
    const HealthInfoScreen(),
    const NearestFacilitiesScreen(),
    const EmergencyServicesScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final localizationService = Provider.of<LocalizationService>(context);

    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.health_and_safety),
            label: localizationService.translate('health_info'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.local_hospital),
            label: localizationService.translate('nearest_facilities'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.emergency),
            label: localizationService.translate('emergency_services'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person),
            label: localizationService.translate('profile'),
          ),
        ],
      ),
    );
  }
}

