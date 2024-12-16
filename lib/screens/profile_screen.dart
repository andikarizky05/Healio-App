import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../services/localization_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authService = Provider.of<AuthService>(context, listen: false);
      if (authService.isAuthenticated) {
        _nameController.text = authService.currentUser?.name ?? '';
        _emailController.text = authService.currentUser?.email ?? '';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final localizationService = Provider.of<LocalizationService>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              if (authService.isAuthenticated)
                _buildLoggedInView(authService, localizationService)
              else
                _buildAuthForm(authService, localizationService),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoggedInView(AuthService authService, LocalizationService localizationService) {
    return Column(
      children: [
        const CircleAvatar(
          radius: 50,
          backgroundColor: Colors.blue,
          child: Icon(Icons.person, size: 50, color: Colors.white),
        ),
        const SizedBox(height: 20),
        Text(
          authService.currentUser?.name ?? 'No name',
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Text(
          authService.currentUser?.email ?? 'No email',
          style: const TextStyle(fontSize: 16, color: Colors.grey),
        ),
        const SizedBox(height: 30),
        if (_isEditing) _buildEditForm(authService, localizationService) else _buildProfileActions(authService, localizationService),
        const SizedBox(height: 20),
        _buildLanguageSelector(localizationService),
      ],
    );
  }

  Widget _buildProfileActions(AuthService authService, LocalizationService localizationService) {
    return Column(
      children: [
        ElevatedButton.icon(
          onPressed: () {
            setState(() {
              _isEditing = true;
            });
          },
          icon: const Icon(Icons.edit),
          label: Text(localizationService.translate('edit_profile')),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          ),
        ),
        const SizedBox(height: 10),
        ElevatedButton.icon(
          onPressed: () {
            authService.logout();
          },
          icon: const Icon(Icons.logout),
          label: Text(localizationService.translate('logout')),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          ),
        ),
      ],
    );
  }

  Widget _buildEditForm(AuthService authService, LocalizationService localizationService) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: localizationService.translate('name'),
              border: const OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your name';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: localizationService.translate('email'),
              border: const OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                final success = await authService.updateProfile(
                  _nameController.text,
                  _emailController.text,
                );
                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Profile updated successfully')),
                  );
                  setState(() {
                    _isEditing = false;
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Failed to update profile')),
                  );
                }
              }
            },
            child: Text(localizationService.translate('save_changes')),
          ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: () {
              setState(() {
                _isEditing = false;
              });
            },
            child: Text(localizationService.translate('cancel')),
          ),
        ],
      ),
    );
  }

  Widget _buildAuthForm(AuthService authService, LocalizationService localizationService) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                localizationService.translate('login'),
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: localizationService.translate('email'),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  prefixIcon: const Icon(Icons.email),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: localizationService.translate('password'),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  prefixIcon: const Icon(Icons.lock),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final success = await authService.login(
                      _emailController.text,
                      _passwordController.text,
                    );
                    if (success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Logged in successfully')),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Invalid credentials')),
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: Text(localizationService.translate('login')),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/register');
                },
                child: Text(localizationService.translate('need_account')),
              ),
              const SizedBox(height: 20),
              _buildLanguageSelector(localizationService),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageSelector(LocalizationService localizationService) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localizationService.translate('language'),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () => localizationService.setLanguage('en'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: localizationService.currentLanguage == 'en' ? Colors.blue : Colors.grey,
                ),
                child: Text(localizationService.translate('english')),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton(
                onPressed: () => localizationService.setLanguage('id'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: localizationService.currentLanguage == 'id' ? Colors.blue : Colors.grey,
                ),
                child: Text(localizationService.translate('indonesian')),
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }
}

