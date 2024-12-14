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
      print('User registered successfully: ${newUser.email}');
      return true;
    } catch (e) {
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
        print('User logged in successfully: ${user.email}');
        return true;
      }
      print('Login failed: Invalid credentials');
      return false;
    } catch (e) {
      print('Error during login: $e');
      return false;
    }
  }

  void logout() {
    _isAuthenticated = false;
    _currentUser = null;
    notifyListeners();
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
        print('Profile updated successfully for user: ${updatedUser.email}');
        return true;
      }
      print('Profile update failed: No current user');
      return false;
    } catch (e) {
      print('Error updating profile: $e');
      return false;
    }
  }
}

