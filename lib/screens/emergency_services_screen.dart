import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class EmergencyServicesScreen extends StatelessWidget {
  const EmergencyServicesScreen({Key? key}) : super(key: key);

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
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Emergency Services',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.greenAccent,
      ),
      backgroundColor: Colors.white, // Added backgroundColor
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildEmergencyCard(
              context,
              'Ambulance',
              Icons.emergency,
              'Call Emergency Ambulance',
              () => _makePhoneCall('911'),
              Colors.red,
            ),
            const SizedBox(height: 16),
            _buildEmergencyCard(
              context,
              'Health Center',
              Icons.local_hospital,
              'Find Nearest Health Center',
              () {
                // TODO: Implement navigation to nearest health center
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Searching for nearest health center...')),
                );
              },
              Colors.blue,
            ),
            const SizedBox(height: 16),
            _buildEmergencyCard(
              context,
              'Doctor',
              Icons.medical_services,
              'Contact On-Call Doctor',
              () {
                // TODO: Implement doctor contact functionality
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Connecting to available doctor...')),
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

