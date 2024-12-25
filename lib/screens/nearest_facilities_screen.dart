import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/localization_service.dart';

class NearestFacilitiesScreen extends StatefulWidget {
  const NearestFacilitiesScreen({Key? key}) : super(key: key);

  @override
  _NearestFacilitiesScreenState createState() => _NearestFacilitiesScreenState();
}

class _NearestFacilitiesScreenState extends State<NearestFacilitiesScreen> {
  final List<Map<String, String>> _facilities = [
    {
      'name': 'Bidan Desa Randugong',
      'address': '7VH8+VJC, Tamanan, Randu Gong, Kec. Kejayan, Pasuruan, Jawa Timur 67172',
      'distance': '1.5 km',
      'image': 'assets/hospitals/BidanDesa.jpeg',
      'maps_link': 'https://maps.app.goo.gl/n1FToFYexWVb8XdN6',
    },
    {
      'name': 'Puskesmas Kejayan',
      'address': 'Jl. Lembu Suro No.1, Krajan, Kejayan, Kec. Kejayan, Pasuruan, Jawa Timur 67172',
      'distance': '5.8 km',
      'image': 'assets/hospitals/PuskesmanKejayan.JPG',
      'maps_link': 'https://maps.app.goo.gl/yL546aAbWvdiuJzaA',
    },
    {
      'name': 'Rumah Sakit Umum Daerah Dr. R. Soedarsono',
      'address': 'Jl. Dokter Wahidin Sudiro Husodo No.1-4, Purutrejo, Kec. Purworejo, Kota Pasuruan, Jawa Timur 67117',
      'distance': '8.2 km',
      'image': 'assets/hospitals/RSUD_SOEDARSONO.jpeg',
      'maps_link': 'https://maps.app.goo.gl/BXS1Cks1NErWVCMfA',
    },
  ];

  Future<void> _launchMaps(String mapsLink) async {
    if (await canLaunch(mapsLink)) {
      await launch(mapsLink);
    } else {
      throw 'Could not launch $mapsLink';
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizationService = Provider.of<LocalizationService>(context);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          localizationService.translate('nearest_facilities'),
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: _facilities.length,
          itemBuilder: (context, index) {
            final facility = _facilities[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 16.0),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: InkWell(
                onTap: () {
                  // TODO: Navigate to facility details
                },
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Hospital Image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          facility['image']!,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.local_hospital,
                                    size: 40,
                                    color: Colors.grey[400],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    localizationService.translate('no_image'),
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 12,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Hospital Information
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              facility['name']!,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              facility['address']!,
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${localizationService.translate("distance")}: ${facility['distance']}',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    _launchMaps(facility['maps_link']!);
                                  },
                                  child: Text(
                                    localizationService.translate('get_directions'),
                                    style: const TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

