import 'dart:convert';
import 'package:http/http.dart' as http;

class FoodEnforcement {
  final String eventId;
  final String recallNumber;
  final String recallingFirm;
  final String productDescription;
  final String reasonForRecall;
  final String status;
  final String classification;
  final String reportDate;
  final String country;
  final String city;
  final String state;
  final String distributionPattern;
  final String productQuantity;
  final String initialFirmNotification;
  final String voluntaryMandated;

  FoodEnforcement({
    required this.eventId,
    required this.recallNumber,
    required this.recallingFirm,
    required this.productDescription,
    required this.reasonForRecall,
    required this.status,
    required this.classification,
    required this.reportDate,
    required this.country,
    required this.city,
    required this.state,
    required this.distributionPattern,
    required this.productQuantity,
    required this.initialFirmNotification,
    required this.voluntaryMandated,
  });

  factory FoodEnforcement.fromJson(Map<String, dynamic> json) {
    return FoodEnforcement(
      eventId: json['event_id'] ?? 'Unknown',
      recallNumber: json['recall_number'] ?? 'Unknown',
      recallingFirm: json['recalling_firm'] ?? 'Unknown',
      productDescription: json['product_description'] ?? 'No description available',
      reasonForRecall: json['reason_for_recall'] ?? 'No reason provided',
      status: json['status'] ?? 'Unknown',
      classification: json['classification'] ?? 'Unknown',
      reportDate: json['report_date'] ?? '',
      country: json['country'] ?? 'Unknown',
      city: json['city'] ?? 'Unknown',
      state: json['state'] ?? 'Unknown',
      distributionPattern: json['distribution_pattern'] ?? 'Unknown',
      productQuantity: json['product_quantity'] ?? 'Unknown',
      initialFirmNotification: json['initial_firm_notification'] ?? 'Unknown',
      voluntaryMandated: json['voluntary_mandated'] ?? 'Unknown',
    );
  }

  Map<String, String> toMap() {
    return {
      // ignore: unnecessary_brace_in_string_interps
      'title': 'Food Recall: ${recallingFirm}',
      'description': productDescription,
      'reason': reasonForRecall,
      'date': reportDate,
      'source': 'FDA Food Enforcement',
      'status': status,
      'classification': classification,
      'country': country,
      'state': state,
      'city': city,
      'distribution': distributionPattern,
      'quantity': productQuantity,
      'notification': initialFirmNotification,
      'voluntary': voluntaryMandated,
      'recall_number': recallNumber,
      'event_id': eventId,
      'content': 'Reason for Recall: $reasonForRecall\n\nProduct: $productDescription\n\nStatus: $status\n\nClassification: $classification\n\nDistribution: $distributionPattern\n\nQuantity: $productQuantity',
      'imageUrl': '',
      'url': 'https://www.fda.gov/safety/recalls-market-withdrawals-safety-alerts',
    };
  }
}

class NewsService {
  static const String _baseUrl = 'https://api.fda.gov/food/enforcement.json';

  Future<List<FoodEnforcement>> getFoodEnforcements({int limit = 25}) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl?limit=$limit'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        
        if (data.containsKey('results')) {
          final List<dynamic> results = data['results'];
          return results.map((result) => FoodEnforcement.fromJson(result)).toList();
        } else {
          throw Exception('No results found in API response');
        }
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching food enforcements: $e');
      return [];
    }
  }

  Future<List<FoodEnforcement>> searchFoodEnforcements(String query, {int limit = 25}) async {
    try {
      // Search in product description or recalling firm
      final response = await http.get(
        Uri.parse('$_baseUrl?search=product_description:"$query"+recalling_firm:"$query"&limit=$limit'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        
        if (data.containsKey('results')) {
          final List<dynamic> results = data['results'];
          return results.map((result) => FoodEnforcement.fromJson(result)).toList();
        } else {
          return [];
        }
      } else if (response.statusCode == 404) {
        // No results found is a valid response
        return [];
      } else {
        throw Exception('Failed to search data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error searching food enforcements: $e');
      return [];
    }
  }
}

