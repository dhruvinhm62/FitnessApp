import 'package:flutter/material.dart';

class StatisticsTabView extends StatelessWidget {
  const StatisticsTabView({super.key});

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
                'Performance',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: Colors.black,
                  letterSpacing: -1.0,
                ),
              ),
              const SizedBox(height: 24),
              _buildMetricCard(
                'Total Volume',
                '14,500 lbs',
                '+12% from last week',
                Icons.trending_up,
                const Color(0xFFC4F252),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildSmallMetricCard('Workouts', '12', Icons.fitness_center),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildSmallMetricCard('Active Time', '8h 45m', Icons.timer),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              const Text(
                'Weekly Activity',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Colors.black,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 16),
              _buildChartPlaceholder(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetricCard(String title, String value, String subtitle, IconData icon, Color highlightColor) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(color: Colors.white70, fontSize: 16, fontWeight: FontWeight.w500),
              ),
              Icon(icon, color: highlightColor),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.w800,
              letterSpacing: -1.0,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(color: highlightColor, fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildSmallMetricCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.blueAccent, size: 28),
          const SizedBox(height: 16),
          Text(
            value,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800, letterSpacing: -0.5),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(color: Colors.grey[600], fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildChartPlaceholder() {
    return Container(
      height: 200,
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
      child: Column(
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildBar(0.4),
                _buildBar(0.7),
                _buildBar(0.5),
                _buildBar(0.9, isHighlighted: true),
                _buildBar(0.6),
                _buildBar(0.3),
                _buildBar(0.8),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text('M', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
              Text('T', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
              Text('W', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
              Text('T', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)), // Highlighted
              Text('F', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
              Text('S', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
              Text('S', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildBar(double heightFactor, {bool isHighlighted = false}) {
    return FractionallySizedBox(
      heightFactor: heightFactor,
      child: Container(
        width: 12,
        decoration: BoxDecoration(
          color: isHighlighted ? const Color(0xFFC4F252) : Colors.grey[200],
          borderRadius: BorderRadius.circular(6),
        ),
      ),
    );
  }
}
