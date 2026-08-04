import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WorkoutTabView extends StatelessWidget {
  const WorkoutTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(left: 24, right: 24, top: 16, bottom: 120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Workouts',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: Colors.black,
                  letterSpacing: -1.0,
                ),
              ),
              const SizedBox(height: 24),
              _buildFeaturedWorkout(),
              const SizedBox(height: 32),
              const Text(
                'Your Routines',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Colors.black,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 16),
              _buildRoutineCard('Chest & Triceps', '45 mins • 6 Exercises', Icons.fitness_center, Colors.orangeAccent),
              const SizedBox(height: 16),
              _buildRoutineCard('Back & Biceps', '50 mins • 7 Exercises', Icons.rowing, Colors.blueAccent),
              const SizedBox(height: 16),
              _buildRoutineCard('Leg Day', '60 mins • 5 Exercises', Icons.directions_run, Colors.purpleAccent),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturedWorkout() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(32),
        image: DecorationImage(
          image: const NetworkImage('https://images.unsplash.com/photo-1517836357463-d25dfeac3438?w=800&q=80'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.darken),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFC4F252),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'PRO PLAN',
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
          const SizedBox(height: 60),
          const Text(
            'Shred & Tone\nMasterclass',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w800,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 12),
          const Row(
            children: [
              Icon(Icons.timer_outlined, color: Colors.white70, size: 18),
              SizedBox(width: 4),
              Text('4 Weeks', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w500)),
              SizedBox(width: 16),
              Icon(Icons.local_fire_department_outlined, color: Colors.white70, size: 18),
              SizedBox(width: 4),
              Text('Advanced', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w500)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRoutineCard(String title, String subtitle, IconData icon, Color iconColor) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(icon, color: iconColor, size: 30),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: -0.5),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600], fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
    );
  }
}
