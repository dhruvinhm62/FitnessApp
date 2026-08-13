import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../data/models/workout_models.dart';

void showTargetsModal(BuildContext context, Exercise exercise) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => _WorkoutTargetsModal(exercise: exercise),
  );
}

class _WorkoutTargetsModal extends StatefulWidget {
  final Exercise exercise;
  const _WorkoutTargetsModal({required this.exercise});

  @override
  State<_WorkoutTargetsModal> createState() => _WorkoutTargetsModalState();
}

class _WorkoutTargetsModalState extends State<_WorkoutTargetsModal> {
  bool _setRestTimers = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        children: [
          // Drag handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.close, color: AppColors.black),
                  onPressed: () => Get.back(),
                ),
                Column(
                  children: [
                    const Text('Targets', style: TextStyle(color: AppColors.black, fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(widget.exercise.name, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                  ],
                ),
                const SizedBox(width: 48), // balance the close icon
              ],
            ),
          ),
          
          Divider(color: Colors.grey[300], height: 32),
          
          // Table Headers
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const SizedBox(width: 40, child: Text('Set', style: TextStyle(color: AppColors.black, fontSize: 13))),
                const Expanded(child: Text('Reps Min', textAlign: TextAlign.center, style: TextStyle(color: AppColors.black, fontSize: 13))),
                const Expanded(child: Text('Reps Max', textAlign: TextAlign.center, style: TextStyle(color: AppColors.black, fontSize: 13))),
                const Expanded(child: Text('Rest', textAlign: TextAlign.center, style: TextStyle(color: AppColors.black, fontSize: 13))),
                SizedBox(width: 40, child: Text('RIR', textAlign: TextAlign.center, style: TextStyle(color: AppColors.black, fontSize: 13))),
              ],
            ),
          ),
          const SizedBox(height: 16),
          
          // List of targets
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: widget.exercise.targetSets.length + 1,
              itemBuilder: (context, index) {
                if (index == widget.exercise.targetSets.length) {
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.only(top: 16),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.add, color: AppColors.black, size: 20),
                    ),
                  );
                }
                
                final target = widget.exercise.targetSets[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      SizedBox(width: 40, child: Text('${target.setNumber}', style: const TextStyle(color: AppColors.black, fontSize: 16, fontWeight: FontWeight.bold))),
                      Expanded(child: _buildInputField('${target.minReps}')),
                      const SizedBox(width: 8),
                      Expanded(child: _buildInputField('${target.maxReps}')),
                      const SizedBox(width: 8),
                      Expanded(child: _buildInputField('${target.restDurationSeconds ~/ 60}:00', isSelected: index == 1)),
                      const SizedBox(width: 8),
                      SizedBox(
                        width: 40,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: AppColors.black,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text('${target.rir}', style: const TextStyle(color: AppColors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                          ),
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
          
          Divider(color: Colors.grey[300], height: 1),
          
          // Footer Options
          Container(
            padding: const EdgeInsets.all(20),
            color: AppColors.white,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Set Rest Timers', style: TextStyle(color: AppColors.black, fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text('This will override default exercise settings', style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                      ],
                    ),
                    Switch(
                      value: _setRestTimers,
                      onChanged: (val) => setState(() => _setRestTimers = val),
                      activeThumbColor: AppColors.black,
                      activeTrackColor: Colors.grey[300],
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () => Get.back(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.black,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Save', style: TextStyle(color: AppColors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField(String value, {bool isSelected = false}) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
        border: isSelected ? Border.all(color: AppColors.black) : null,
      ),
      child: Center(
        child: Text(value, style: const TextStyle(color: AppColors.black, fontSize: 15)),
      ),
    );
  }
}
