import 'package:flutter/material.dart';
import 'package:flutter_application_1/routes/route_names.dart';
import 'package:get/get.dart';
import 'package:flutter_application_1/controllers/home_controller.dart';

class LoginView extends StatelessWidget {
  LoginView({super.key});

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final HomeController controller = Get.find<HomeController>();

  // Reactive variable to toggle password visibility
  final RxBool isPasswordVisible = false.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: Get.mediaQuery.size.height * 0.15),
            Center(
              child: Column(
                children: [
                  Image.asset("assets/icon.png",
                      width: Get.mediaQuery.size.width * 0.5),
                  const Text('Task Track',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue)),
                ],
              ),
            ),
            const SizedBox(height: 15),
            const Text('Please log in to access your tasks',
                style: TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            SizedBox(
              width: Get.mediaQuery.size.width * 0.8,
              child: TextFormField(
                controller: emailController,
                cursorColor: Colors.blue,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.email),
                  labelText: 'Email',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.blue)),
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: Get.mediaQuery.size.width * 0.8,
              child: Obx(
                () => TextFormField(
                  controller: passwordController,
                  cursorColor: Colors.blue,
                  obscureText: !isPasswordVisible.value, // Toggle visibility
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock),
                    labelText: 'Password',
                    suffixIcon: IconButton(
                      icon: Icon(
                        isPasswordVisible.value
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        isPasswordVisible.value = !isPasswordVisible.value;
                      },
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.blue)),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => controller.login(
                  emailController.text.trim(), passwordController.text.trim()),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  minimumSize: Size(Get.mediaQuery.size.width * 0.8, 50)),
              child: const Text('Login',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16)),
            ),
            const SizedBox(height: 20),
            InkWell(
                onTap: () => Get.toNamed(RouteNames.resetPassword),
                child: const Text("Forgot Password?",
                    style: TextStyle(color: Colors.blue))),
            const SizedBox(height: 20),
            InkWell(
                onTap: () => Get.offNamed(RouteNames.signup),
                child: const Text("Don't have an account? Sign up",
                    style: TextStyle(color: Colors.blue))),
          ],
        ),
      ),
    );
  }
}
