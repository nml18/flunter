import 'package:flutter/material.dart';
import 'package:flunter/services/api_service.dart';

class RegisterScreen extends StatefulWidget {  
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;        
  bool _obscureConfirmPassword = true;  

  void _attemptToCreateAccount(BuildContext context) {
    String username = _usernameController.text.trim();
    String password = _passwordController.text;
    String confirmPassword = _confirmPasswordController.text;

    if (username.isEmpty) {
      _showMessage(context, 'Please enter a username', isError: true);
      return;
    }
    
    if (password.isEmpty) {
      _showMessage(context, 'Please enter a password', isError: true);
      return;
    }

    if (confirmPassword.isEmpty) {
      _showMessage(context, 'Please confirm the password', isError: true);
      return;
    }

    if (password != confirmPassword) {
      _showMessage(context, 'Passwords are not the same', isError: true);
      return;
    }
    
    _createAccount(context, username, password);
  }    

  void _showMessage(BuildContext context, String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }
  
  void _createAccount(BuildContext context, String username, String password) async {
    final result = await ApiService().register(username, password);

    if (!context.mounted) return;

    if (result['success'] == true) {
      _showMessage(context, result['message']);
      Navigator.pop(context);
    } else {
      _showMessage(context, result['error'] ?? 'Unknown error', isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account registration'),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 10),
            SizedBox(
              width: 300,
              child: TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8)
                  ),
                  prefixIcon: const Icon(Icons.person),
                )
              ),
            ),
            const SizedBox(height: 10),

            SizedBox(
              width: 300,
              child: TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,  
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8)
                  ),
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                )
              ),
            ),
            const SizedBox(height: 10),

            SizedBox(
              width: 300,
              child: TextField(
                controller: _confirmPasswordController,
                obscureText: _obscureConfirmPassword,  
                decoration: InputDecoration(
                  labelText: 'Confirm password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8)
                  ),
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                  ),
                )
              ),
            ),
            const SizedBox(height: 24),
            
            ElevatedButton(
              onPressed: () => _attemptToCreateAccount(context),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(200, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Create',
                style: TextStyle(fontSize: 18),
              ),
            )
          ],
        )
      ),
    );
  }
}