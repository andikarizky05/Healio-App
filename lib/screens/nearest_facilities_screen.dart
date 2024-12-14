import 'package:flutter/material.dart';

class NearestFacilitiesScreen extends StatefulWidget {
  const NearestFacilitiesScreen({Key? key}) : super(key: key);

  @override
  _NearestFacilitiesScreenState createState() => _NearestFacilitiesScreenState();
}

class _NearestFacilitiesScreenState extends State<NearestFacilitiesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.local_hospital, size: 100, color: Colors.green),
            const SizedBox(height: 20),
            const Text(
              'Nearest Health Facilities',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // TODO: Implement nearest facilities functionality
              },
              child: const Text('Find Nearby Facilities'),
            ),
          ],
        ),
      ),
    );
  }
}

