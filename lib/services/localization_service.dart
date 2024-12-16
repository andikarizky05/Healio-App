import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalizationService extends ChangeNotifier {
  static const String _languageKey = 'language';
  static const String _englishCode = 'en';
  static const String _indonesianCode = 'id';

  String _currentLanguage = _englishCode;

  String get currentLanguage => _currentLanguage;

  final Map<String, Map<String, String>> _localizedValues = {
    _englishCode: {
      'health_info': 'Health Info',
      'nearest_facilities': 'Nearest Facilities',
      'emergency_services': 'Emergency Services',
      'profile': 'Profile',
      'edit_profile': 'Edit Profile',
      'logout': 'Logout',
      'name': 'Name',
      'email': 'Email',
      'password': 'Password',
      'save_changes': 'Save Changes',
      'cancel': 'Cancel',
      'login': 'Login',
      'register': 'Register',
      'need_account': 'Need an account? Register',
      'have_account': 'Have an account? Login',
      'language': 'Language',
      'english': 'English',
      'indonesian': 'Indonesian',
      'search_health_info': 'Search health information...',
      'read_more': 'Read More',
      'find_nearby_facilities': 'Find Nearby Facilities',
      'ambulance': 'Ambulance',
      'health_center': 'Health Center',
      'doctor': 'Doctor',
      'call_ambulance': 'Call Emergency Ambulance',
      'find_health_center': 'Find Nearest Health Center',
      'contact_doctor': 'Contact On-Call Doctor',
    },
    _indonesianCode: {
      'health_info': 'Informasi Kesehatan',
      'nearest_facilities': 'Fasilitas Terdekat',
      'emergency_services': 'Layanan Darurat',
      'profile': 'Profil',
      'edit_profile': 'Edit Profil',
      'logout': 'Keluar',
      'name': 'Nama',
      'email': 'Email',
      'password': 'Kata Sandi',
      'save_changes': 'Simpan Perubahan',
      'cancel': 'Batal',
      'login': 'Masuk',
      'register': 'Daftar',
      'need_account': 'Belum punya akun? Daftar',
      'have_account': 'Sudah punya akun? Masuk',
      'language': 'Bahasa',
      'english': 'Inggris',
      'indonesian': 'Indonesia',
      'search_health_info': 'Cari informasi kesehatan...',
      'read_more': 'Baca Selengkapnya',
      'find_nearby_facilities': 'Temukan Fasilitas Terdekat',
      'ambulance': 'Ambulans',
      'health_center': 'Pusat Kesehatan',
      'doctor': 'Dokter',
      'call_ambulance': 'Panggil Ambulans Darurat',
      'find_health_center': 'Temukan Pusat Kesehatan Terdekat',
      'contact_doctor': 'Hubungi Dokter Jaga',
    },
  };

  LocalizationService() {
    _loadLanguagePreference();
  }

  Future<void> _loadLanguagePreference() async {
    final prefs = await SharedPreferences.getInstance();
    _currentLanguage = prefs.getString(_languageKey) ?? _englishCode;
    notifyListeners();
  }

  Future<void> setLanguage(String languageCode) async {
    if (_localizedValues.containsKey(languageCode)) {
      _currentLanguage = languageCode;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_languageKey, languageCode);
      notifyListeners();
    }
  }

  String translate(String key) {
    return _localizedValues[_currentLanguage]?[key] ?? key;
  }
}

