import 'package:amazon_clone/core/app_colors.dart';
import 'package:amazon_clone/screens/home/bottom_nav_bar.dart';
import 'package:amazon_clone/widgets/custom_input.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: const Text(
          "amazon",
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 40),

                  const Text(
                    "Welcome Back!",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 30),

                  /// ✅ Email Field
                  TextFormField(
                    controller: _emailCtrl,
                    decoration: appInput("Email", Icons.email),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Please enter email";
                      }
                      if (!value.contains("@")) {
                        return "Enter valid email";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  /// ✅ Password Field
                  TextFormField(
                    controller: _passCtrl,
                    decoration: appInput("Password", Icons.lock),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Please enter password";
                      }
                      if (value.trim().length < 6) {
                        return "Password must be at least 6 characters";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 30),

                  /// ✅ Login Button
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                      ),
                      onPressed: auth.isLoading
                          ? null
                          : () async {
                              if (!_formKey.currentState!.validate()) return;

                              context.read<BottomNavProvider>().setIndex(0);
                              final error = await auth.loginWithEmail(
                                _emailCtrl.text.trim(),
                                _passCtrl.text.trim(),
                              );

                              if (error == null) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => BottomNavScreen()),
                                );
                              }
                            },
                      child: const Text("Sign In",
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  const SizedBox(height: 12),

                  /// ✅ Register Button
                  TextButton(
                    onPressed: auth.isLoading
                        ? null
                        : () async {
                            if (!_formKey.currentState!.validate()) return;

                            context.read<BottomNavProvider>().setIndex(0);
                            final error = await auth.registerWithEmail(
                              _emailCtrl.text.trim(),
                              _passCtrl.text.trim(),
                            );

                            if (error == null) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => BottomNavScreen()),
                              );
                            }
                          },
                    child: const Text("Create New Account"),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),

          /// ✅ Loading Overlay
          if (auth.isLoading)
            Container(
              color: Colors.black.withOpacity(0.25),
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}
