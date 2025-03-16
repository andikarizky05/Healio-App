import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// ignore: unused_import
import 'package:intl/intl.dart';
import '../services/auth_service.dart';
import '../services/localization_service.dart';
import '../services/notification_service.dart';
import '../services/news_service.dart';
import 'health_info_detail_screen.dart';

class HealthInfoScreen extends StatefulWidget {
  // ignore: use_super_parameters
  const HealthInfoScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HealthInfoScreenState createState() => _HealthInfoScreenState();
}

class _HealthInfoScreenState extends State<HealthInfoScreen> {
  final TextEditingController _searchController = TextEditingController();
  final NewsService _newsService = NewsService();
  
  List<FoodEnforcement> _foodEnforcements = [];
  List<FoodEnforcement> _filteredEnforcements = [];
  bool _isLoading = true;
  bool _isSearching = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchFoodEnforcements();
  }

  Future<void> _fetchFoodEnforcements() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final enforcements = await _newsService.getFoodEnforcements();
      
      setState(() {
        _foodEnforcements = enforcements;
        _filteredEnforcements = enforcements;
        _isLoading = false;
      });
      
      _addEnforcementNotifications();
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load food safety data. Please try again later.';
        _isLoading = false;
      });
    }
  }

  Future<void> _searchFoodEnforcements(String query) async {
    if (query.isEmpty) {
      setState(() {
        _filteredEnforcements = _foodEnforcements;
        _isSearching = false;
      });
      return;
    }

    setState(() {
      _isSearching = true;
    });

    try {
      final results = await _newsService.searchFoodEnforcements(query);
      
      setState(() {
        _filteredEnforcements = results;
        _isSearching = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Search failed. Please try again.';
        _isSearching = false;
      });
    }
  }

  void _addEnforcementNotifications() {
    final notificationService = Provider.of<NotificationService>(context, listen: false);
    
    // Only add notifications for the first 3 items
    for (var i = 0; i < _foodEnforcements.length && i < 3; i++) {
      final enforcement = _foodEnforcements[i];
      notificationService.addNotification({
        'title': 'Food Recall: ${enforcement.recallingFirm}',
        'body': enforcement.productDescription,
        'date': _formatDate(enforcement.reportDate),
      });
    }
  }

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

  void _showNotifications(BuildContext context) {
    final notificationService = Provider.of<NotificationService>(context, listen: false);
    final localizationService = Provider.of<LocalizationService>(context, listen: false);

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                localizationService.translate('notifications'),
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: notificationService.notifications.isEmpty
                    ? Center(
                        child: Text(localizationService.translate('no_notifications')),
                      )
                    : ListView.builder(
                        itemCount: notificationService.notifications.length,
                        itemBuilder: (context, index) {
                          final notification = notificationService.notifications[index];
                          return ListTile(
                            title: Text(notification['title']!),
                            subtitle: Text(notification['body']!),
                            trailing: Text(notification['date']!),
                          );
                        },
                      ),
              ),
              ElevatedButton(
                onPressed: () {
                  notificationService.clearNotifications();
                  Navigator.pop(context);
                },
                child: Text(localizationService.translate('clear_notifications')),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final localizationService = Provider.of<LocalizationService>(context);
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.blue,
              child: Text(
                authService.currentUser?.name.substring(0, 1).toUpperCase() ?? 'G',
                style: const TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Food Safety Alerts',
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Text(
                  authService.currentUser?.name ?? localizationService.translate('guest_user'),
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.black),
            onPressed: () => _showNotifications(context),
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.black),
            onPressed: _fetchFoodEnforcements,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search food recalls...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                filled: true,
                fillColor: Colors.grey[100],
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _searchFoodEnforcements('');
                        },
                      )
                    : null,
              ),
              onSubmitted: _searchFoodEnforcements,
              onChanged: (value) {
                if (value.isEmpty) {
                  _searchFoodEnforcements('');
                }
              },
            ),
            const SizedBox(height: 16),
            
            Expanded(
              child: _buildEnforcementContent(localizationService),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEnforcementContent(LocalizationService localizationService) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_isSearching) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Searching...'),
          ],
        ),
      );
    }

    if (_errorMessage.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _errorMessage,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _fetchFoodEnforcements,
              child: Text(localizationService.translate('retry')),
            ),
          ],
        ),
      );
    }

    if (_filteredEnforcements.isEmpty) {
      return Center(
        child: Text(
          _searchController.text.isEmpty
              ? 'No food safety alerts available'
              : 'No results found for "${_searchController.text}"',
          style: const TextStyle(fontSize: 16),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _fetchFoodEnforcements,
      child: ListView.builder(
        itemCount: _filteredEnforcements.length,
        itemBuilder: (context, index) {
          final enforcement = _filteredEnforcements[index];
          return Card(
            elevation: 2,
            margin: const EdgeInsets.only(bottom: 12),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HealthInfoDetailScreen(
                      healthInfo: enforcement.toMap(),
                    ),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: _getClassificationColor(enforcement.classification) == 'Dangerous'
                                // ignore: deprecated_member_use
                                ? Colors.red.withOpacity(0.2)
                                : _getClassificationColor(enforcement.classification) == 'Potentially Harmful'
                                    // ignore: deprecated_member_use
                                    ? Colors.orange.withOpacity(0.2)
                                    // ignore: deprecated_member_use
                                    : Colors.blue.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            _getClassificationColor(enforcement.classification),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: _getClassificationColor(enforcement.classification) == 'Dangerous'
                                  ? Colors.red
                                  : _getClassificationColor(enforcement.classification) == 'Potentially Harmful'
                                      ? Colors.orange
                                      : Colors.blue,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            // ignore: deprecated_member_use
                            color: Colors.grey.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            enforcement.status,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Food Recall: ${enforcement.recallingFirm}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      enforcement.productDescription,
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Reason: ${enforcement.reasonForRecall}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Report Date: ${_formatDate(enforcement.reportDate)}',
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 12,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HealthInfoDetailScreen(
                                  healthInfo: enforcement.toMap(),
                                ),
                              ),
                            );
                          },
                          child: Text(localizationService.translate('read_more')),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

