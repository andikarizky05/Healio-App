import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../services/localization_service.dart';
import 'health_info_detail_screen.dart';

class HealthInfoScreen extends StatefulWidget {
  const HealthInfoScreen({Key? key}) : super(key: key);

  @override
  _HealthInfoScreenState createState() => _HealthInfoScreenState();
}

class _HealthInfoScreenState extends State<HealthInfoScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<Map<String, String>> _healthNews = [
    {
      'title': 'Gaya Hidup Sehat',
      'description': 'Gaya hidup sehat adalah sebuah komitmen jangka panjang untuk menjaga atau melakukan beberapa hal agar mampu mendukung fungsi tubuh, sehingga berdampak baik bagi kesehatan.',
      'date': '2024-12-25',
      'source': 'Health and Wellness Institute',
    },
    {
      'title': 'Pentingnya Menjaga Kesehatan Mental',
      'description': 'kesehatan mental sama pentingnya dengan kesehatan tubuh. Sebab, jiwa yang sehat tentu bisa membuat seseorang menjadi lebih produktif.',
      'date': '2024-11-14',
      'source': 'Mental Health Foundation',
    },
    {
      'title': 'Demam Berdarah',
      'description': 'Demam berdarah atau DBD disebabkan oleh virus Dengue. Seseorang bisa terjangkit demam berdarah jika digigit oleh nyamuk Aedes aegypti atau Aedes albopictus yang telah terinfeksi virus Dengue terlebih dahulu.',
      'date': '2024-10-13',
      'source': 'World Health Organization',
    },
  ];

  List<Map<String, String>> _filteredNews = [];

  @override
  void initState() {
    super.initState();
    _filteredNews = _healthNews;
  }

  void _filterNews(String query) {
    setState(() {
      _filteredNews = _healthNews
          .where((news) =>
              news['title']!.toLowerCase().contains(query.toLowerCase()) ||
              news['description']!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
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
                  localizationService.translate('health_info'),
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
            onPressed: () {
              // TODO: Implement notifications functionality
            },
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
                hintText: localizationService.translate('search_health_info'),
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
              onChanged: _filterNews,
            ),
            const SizedBox(height: 16),
            
            Expanded(
              child: ListView.builder(
                itemCount: _filteredNews.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _filteredNews[index]['title']!,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _filteredNews[index]['description']!,
                            style: TextStyle(
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _filteredNews[index]['date']!,
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
                                        healthInfo: _filteredNews[index],
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
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

