import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../models/user.dart';
import 'database_helper.dart';

class AuthService extends ChangeNotifier {
  bool _isAuthenticated = false;
  bool _isInitializing = true;
  User? _currentUser;

  bool get isAuthenticated => _isAuthenticated;
  bool get isInitializing => _isInitializing;
  User? get currentUser => _currentUser;

  AuthService() {
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Simulate app initialization (e.g., loading preferences, checking auth state)
    await Future.delayed(const Duration(seconds: 2));
    _isInitializing = false;
    notifyListeners();
  }

  Future<bool> register(String email, String password, String name) async {
    try {
      final existingUser = await DatabaseHelper.instance.getUser(email);
      if (existingUser != null) {
        // ignore: avoid_print
        print('Registration failed: User with this email already exists');
        return false;
      }

      final newUser = User(
        id: const Uuid().v4(),
        email: email,
        password: password,
        name: name,
      );

      await DatabaseHelper.instance.createUser(newUser);
      // ignore: avoid_print
      print('User registered successfully: ${newUser.email}');
      return true;
    } catch (e) {
      // ignore: avoid_print
      print('Error during registration: $e');
      return false;
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      final user = await DatabaseHelper.instance.getUser(email);
      if (user != null && user.password == password) {
        _isAuthenticated = true;
        _currentUser = user;
        notifyListeners();
        // ignore: avoid_print
        print('User logged in successfully: ${user.email}');
        return true;
      }
      // ignore: avoid_print
      print('Login failed: Invalid credentials');
      return false;
    } catch (e) {
      // ignore: avoid_print
      print('Error during login: $e');
      return false;
    }
  }

  void logout() {
    _isAuthenticated = false;
    _currentUser = null;
    notifyListeners();
    // ignore: avoid_print
    print('User logged out');
  }

  Future<bool> updateProfile(String name, String email) async {
    try {
      if (_currentUser != null) {
        final updatedUser = User(
          id: _currentUser!.id,
          email: email,
          password: _currentUser!.password,
          name: name,
        );
        await DatabaseHelper.instance.updateUser(updatedUser);
        _currentUser = updatedUser;
        notifyListeners();
        // ignore: avoid_print
        print('Profile updated successfully for user: ${updatedUser.email}');
        return true;
      }
      // ignore: avoid_print
      print('Profile update failed: No current user');
      return false;
    } catch (e) {
      // ignore: avoid_print
      print('Error updating profile: $e');
      return false;
    }
  }
}

