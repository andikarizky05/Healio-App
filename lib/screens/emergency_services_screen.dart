import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import '../services/localization_service.dart';

class EmergencyServicesScreen extends StatelessWidget {
  const EmergencyServicesScreen({super.key});

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      throw 'Could not launch $phoneNumber';
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizationService = Provider.of<LocalizationService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          localizationService.translate('emergency_services'),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.greenAccent,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildEmergencyCard(
              context,
              localizationService.translate('ambulance'),
              Icons.emergency,
              localizationService.translate('call_ambulance'),
              () => _makePhoneCall('911'),
              Colors.red,
            ),
            const SizedBox(height: 16),
            _buildEmergencyCard(
              context,
              localizationService.translate('health_center'),
              Icons.local_hospital,
              localizationService.translate('find_health_center'),
              () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(localizationService.translate('searching_health_center'))),
                );
              },
              Colors.blue,
            ),
            const SizedBox(height: 16),
            _buildEmergencyCard(
              context,
              localizationService.translate('doctor'),
              Icons.medical_services,
              localizationService.translate('contact_doctor'),
              () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(localizationService.translate('connecting_doctor'))),
                );
              },
              Colors.green,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmergencyCard(
    BuildContext context,
    String title,
    IconData icon,
    String description,
    VoidCallback onTap,
    Color color,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: 32,
                  color: color,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey[400],
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

