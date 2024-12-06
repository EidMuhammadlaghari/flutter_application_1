import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter_application_1/routes/route_names.dart';

class ResetPasswordView extends GetWidget {
  const ResetPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();

    Future<void> _sendPasswordResetEmail(String email) async {
      final FirebaseAuth auth = FirebaseAuth.instance;

      try {
        // Attempt to send password reset email
        await auth.sendPasswordResetEmail(email: email);

        // Provide a generic success message
        Get.snackbar(
          'Success',
          'If this email is registered, a password reset link has been sent.',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } catch (e) {
        // Handle errors
        Get.snackbar(
          'Error',
          'An error occurred while attempting to reset the password.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        print('Error sending password reset email: $e');
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: Get.mediaQuery.size.height * 0.3,
            ),
            const Center(
              child: Text(
                'Task Track',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 15),
            SizedBox(
              width: Get.mediaQuery.size.width * 0.8,
              child: const Text(
                'Please enter your email for reset password link',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: Get.mediaQuery.size.width * 0.8,
              child: TextFormField(
                controller: emailController,
                cursorColor: Colors.blue,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.email),
                  labelText: 'Email',
                  labelStyle: const TextStyle(color: Colors.black87),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.blue),
                  ),
                  focusColor: Colors.blue,
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
              onPressed: () {
                final email = emailController.text.trim();

                if (email.isNotEmpty) {
                  _sendPasswordResetEmail(email);
                } else {
                  Get.snackbar(
                    'Error',
                    'Please enter a valid email.',
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                minimumSize: Size(Get.mediaQuery.size.width * 0.8, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Reset Password',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text("- OR -", style: TextStyle(color: Colors.grey)),
            const SizedBox(
              height: 20,
            ),
            InkWell(
                onTap: () {
                  Get.offNamed(RouteNames.login);
                },
                child:
                    const Text("Login", style: TextStyle(color: Colors.blue))),
          ],
        ),
      ),
    );
  }
}
