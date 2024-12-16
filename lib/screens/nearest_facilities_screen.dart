import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/localization_service.dart';

class NearestFacilitiesScreen extends StatefulWidget {
  const NearestFacilitiesScreen({super.key});

  @override
  _NearestFacilitiesScreenState createState() => _NearestFacilitiesScreenState();
}

class _NearestFacilitiesScreenState extends State<NearestFacilitiesScreen> {
  @override
  Widget build(BuildContext context) {
    final localizationService = Provider.of<LocalizationService>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.local_hospital, size: 100, color: Colors.green),
            const SizedBox(height: 20),
            Text(
              localizationService.translate('nearest_facilities'),
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // TODO: Implement nearest facilities functionality
              },
              child: Text(localizationService.translate('find_nearby_facilities')),
            ),
          ],
        ),
      ),
    );
  }
}

