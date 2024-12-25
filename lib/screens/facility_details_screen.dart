import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/localization_service.dart';

class FacilityDetailsScreen extends StatelessWidget {
  final Map<String, String> facility;

  // ignore: use_super_parameters
  const FacilityDetailsScreen({Key? key, required this.facility}) : super(key: key);

  Future<void> _launchMaps(String mapsLink) async {
    // ignore: deprecated_member_use
    if (await canLaunch(mapsLink)) {
      // ignore: deprecated_member_use
      await launch(mapsLink);
    } else {
      throw 'Could not launch $mapsLink';
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizationService = Provider.of<LocalizationService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          facility['name']!,
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              facility['image']!,
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: double.infinity,
                  height: 200,
                  color: Colors.grey[200],
                  child: Icon(
                    Icons.local_hospital,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    facility['name']!,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    facility['address']!,
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '${localizationService.translate("distance")}: ${facility['distance']}',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => _launchMaps(facility['maps_link']!),
                    icon: const Icon(Icons.directions),
                    label: Text(localizationService.translate('get_directions')),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    localizationService.translate('facility_services'),
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  _buildServicesList(localizationService),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServicesList(LocalizationService localizationService) {
    final services = [
      'emergency_care',
      'outpatient_services',
      'laboratory',
      'pharmacy',
    ];

    return Column(
      children: services.map((service) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.green),
            const SizedBox(width: 8),
            Text(
              localizationService.translate(service),
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      )).toList(),
    );
  }
}

