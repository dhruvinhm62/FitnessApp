import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Wireframe realistic fitness logo representation
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.black, width: 2),
              ),
              child: const Center(
                child: Icon(
                  Icons.fitness_center,
                  size: 60,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'APPNAME',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                letterSpacing: 4,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Your Journey Starts Here',
              style: TextStyle(
                fontSize: 16,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 48),
            // Wireframe style loading indicator
            const SizedBox(
              width: 150,
              child: LinearProgressIndicator(
                backgroundColor: Colors.white,
                color: Colors.black,
                minHeight: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
