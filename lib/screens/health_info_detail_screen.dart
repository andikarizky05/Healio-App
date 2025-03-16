import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/localization_service.dart';

class HealthInfoDetailScreen extends StatelessWidget {
  final Map<String, String> healthInfo;

  const HealthInfoDetailScreen({
    super.key,
    required this.healthInfo,
  });

  String _formatDate(String dateString) {
    try {
      // FDA date format is YYYYMMDD
      if (dateString.length == 8) {
        final year = dateString.substring(0, 4);
        final month = dateString.substring(4, 6);
        final day = dateString.substring(6, 8);
        return '$year-$month-$day';
      }
      return dateString;
    } catch (e) {
      return dateString;
    }
  }

  Future<void> _launchURL(String url) async {
    // ignore: deprecated_member_use
    if (await canLaunch(url)) {
      // ignore: deprecated_member_use
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  String _getClassificationColor(String classification) {
    switch (classification) {
      case 'Class I':
        return 'Dangerous';
      case 'Class II':
        return 'Potentially Harmful';
      case 'Class III':
        return 'Low Risk';
      default:
        return classification;
    }
  }

  Color _getClassificationBgColor(String classification) {
    switch (classification) {
      case 'Class I':
        // ignore: deprecated_member_use
        return Colors.red.withOpacity(0.2);
      case 'Class II':
        // ignore: deprecated_member_use
        return Colors.orange.withOpacity(0.2);
      case 'Class III':
        // ignore: deprecated_member_use
        return Colors.blue.withOpacity(0.2);
      default:
        // ignore: deprecated_member_use
        return Colors.grey.withOpacity(0.2);
    }
  }

  Color _getClassificationTextColor(String classification) {
    switch (classification) {
      case 'Class I':
        return Colors.red;
      case 'Class II':
        return Colors.orange;
      case 'Class III':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final localizationService = Provider.of<LocalizationService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Food Recall Details',
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (healthInfo['url'] != null && healthInfo['url']!.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.share, color: Colors.black),
              onPressed: () {
                // Share functionality would go here
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Share functionality not implemented')),
                );
              },
            ),
        ],
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              color: _getClassificationBgColor(healthInfo['classification'] ?? ''),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _getClassificationColor(healthInfo['classification'] ?? ''),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: _getClassificationTextColor(healthInfo['classification'] ?? ''),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Status: ${healthInfo['status'] ?? 'Unknown'}',
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    healthInfo['title'] ?? '',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Report Date: ${_formatDate(healthInfo['date'] ?? '')}',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Product Description:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    healthInfo['description'] ?? 'No description available',
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Reason for Recall:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    healthInfo['reason'] ?? 'No reason provided',
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 16),
                  _buildDetailRow('Recall Number', healthInfo['recall_number'] ?? 'Unknown'),
                  _buildDetailRow('Event ID', healthInfo['event_id'] ?? 'Unknown'),
                  _buildDetailRow('Distribution', healthInfo['distribution'] ?? 'Unknown'),
                  _buildDetailRow('Quantity', healthInfo['quantity'] ?? 'Unknown'),
                  _buildDetailRow('Country', healthInfo['country'] ?? 'Unknown'),
                  _buildDetailRow('State', healthInfo['state'] ?? 'Unknown'),
                  _buildDetailRow('City', healthInfo['city'] ?? 'Unknown'),
                  _buildDetailRow('Notification Type', healthInfo['notification'] ?? 'Unknown'),
                  _buildDetailRow('Voluntary/Mandated', healthInfo['voluntary'] ?? 'Unknown'),
                  const SizedBox(height: 24),
                  if (healthInfo['url'] != null && healthInfo['url']!.isNotEmpty)
                    Center(
                      child: ElevatedButton.icon(
                        onPressed: () => _launchURL(healthInfo['url']!),
                        icon: const Icon(Icons.language),
                        label: const Text('Visit FDA Recalls Website'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

