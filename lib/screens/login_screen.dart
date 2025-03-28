import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/auth/auth_service.dart';
import '../services/providers/user_provider.dart';
import '../utils/constants/routes.dart';
import '../utils/extensions/context_extension.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Login',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Email',
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _emailController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Enter your Email',
                hintStyle: const TextStyle(color: Colors.white38),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white24),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFF8687E7)),
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.transparent,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Password',
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _passwordController,
              obscureText: true,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: '••••••••',
                hintStyle: const TextStyle(color: Colors.white38),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white24),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFF8687E7)),
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.transparent,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8687E7),
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () async {
                if (_emailController.text.isNotEmpty && _passwordController.text.isNotEmpty) {
                  final response = await AuthService().signInWithEmailAndPassword(
                    _emailController.text,
                    _passwordController.text,
                  );
                  if (response != null && response.username.isNotEmpty) {
                    if (context.mounted) {
                      Provider.of<UserProvider>(context, listen: false).setUser(response);
                      context.navigateRemoveUntil(Routes.main);
                    }
                  } else {
                    if (context.mounted) {
                      context.showMessage("Invalid credentials!");
                    }
                  }
                }
              },
              child: const Text('Login'),
            ),
            const SizedBox(height: 24),
            const Row(
              children: [
                Expanded(child: Divider(color: Colors.white24)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Text('or', style: TextStyle(color: Colors.white54)),
                ),
                Expanded(child: Divider(color: Colors.white24)),
              ],
            ),
            const Spacer(),
            Center(
              child: GestureDetector(
                onTap: () {
                  context.pushReplacement(Routes.register);
                },
                child: RichText(
                  text: const TextSpan(
                    text: "Don't have an account? ",
                    style: TextStyle(color: Colors.white54),
                    children: [
                      TextSpan(
                        text: 'Register',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                        // onTap action can be added here for registration page
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
