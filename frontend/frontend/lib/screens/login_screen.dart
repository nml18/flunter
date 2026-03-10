import 'package:flunter/screens/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:flunter/screens/menu_screen.dart';
import 'package:flunter/services/api_service.dart';

class LoginScreen extends StatefulWidget {  // ← Changé en StatefulWidget
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;  // ← Nouvelle variable

  void _showMessage(BuildContext context, String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  void _attemptToLogin(BuildContext context) async {
    String username = _usernameController.text.trim();
    String password = _passwordController.text;

    if (username.isEmpty) {
      _showMessage(context, 'Please enter a username', isError: true);
      return;
    }

    if (password.isEmpty) {
      _showMessage(context, 'Please enter a password', isError: true);
      return;
    }

    final result = await ApiService().login(username, password);

    if (!context.mounted) return;

    if (result['success'] == true) {
      _showMessage(context, result['message']);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MenuScreen()),
      );
    } else {
      _showMessage(context, result['error'], isError: true);
    }
  }

  void _navigateToRegister(BuildContext context) {
    Navigator.push(
      context, 
      MaterialPageRoute(
        builder: (context) => RegisterScreen()
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('FLUNTER')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 300,
                child: TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    prefixIcon: const Icon(Icons.person),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              
              SizedBox(
                width: 300,
                child: TextField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,  // ← Utilise la variable
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(  // ← Bouton pour basculer
                      icon: Icon(
                        _obscurePassword ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              
              ElevatedButton(
                onPressed: () => _attemptToLogin(context),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(200, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Log in',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(height: 16),
              
              TextButton(
                onPressed: () => _navigateToRegister(context),
                child: const Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}