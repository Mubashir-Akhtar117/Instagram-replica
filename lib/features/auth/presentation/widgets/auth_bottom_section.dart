import 'package:flutter/material.dart';

class AuthBottomSection extends StatelessWidget {
  final VoidCallback onForgotPassword;
  final VoidCallback onFacebookLogin;
  final VoidCallback onSignUp;

  const AuthBottomSection({
    super.key,
    required this.onForgotPassword,
    required this.onFacebookLogin,
    required this.onSignUp,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        TextButton(
          onPressed: onForgotPassword,
          child: const Text(
            "Forgot Password?",
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
        ),
        const SizedBox(height: 60),
        Row(
          children: [
            Expanded(child: Divider(color: Colors.grey[700])),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                "OR",
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ),
            Expanded(child: Divider(color: Colors.grey[700])),
          ],
        ),
        const SizedBox(height: 20),
        TextButton.icon(
          onPressed: onFacebookLogin,
          icon: const Icon(Icons.facebook, color: Colors.blue),
          label: const Text(
            "Log in with Facebook",
            style: TextStyle(color: Colors.blue),
          ),
        ),
        const SizedBox(height: 40),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Don't have an account?",
              style: TextStyle(color: Colors.grey),
            ),
            TextButton(
              onPressed: onSignUp,
              child: const Text(
                "Sign Up",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}