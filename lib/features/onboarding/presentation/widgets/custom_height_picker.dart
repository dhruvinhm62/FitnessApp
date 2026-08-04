import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/onboarding_controller.dart';

class CustomHeightPicker extends StatefulWidget {
  const CustomHeightPicker({super.key});

  @override
  State<CustomHeightPicker> createState() => _CustomHeightPickerState();
}

class _CustomHeightPickerState extends State<CustomHeightPicker> {
  final OnboardingController controller = Get.find<OnboardingController>();
  
  late FixedExtentScrollController _cmController;
  late FixedExtentScrollController _ftInController;

  late int selectedCmIndex;
  late int selectedFtInIndex;

  @override
  void initState() {
    super.initState();
    
    // Initialize CM controller
    selectedCmIndex = (int.tryParse(controller.heightCm.value) ?? 150) - 100;
    _cmController = FixedExtentScrollController(initialItem: selectedCmIndex);

    // Initialize Ft/In controller
    int defaultFt = int.tryParse(controller.heightFt.value) ?? 5;
    int defaultIn = int.tryParse(controller.heightIn.value) ?? 9;
    selectedFtInIndex = ((defaultFt - 4) * 12) + defaultIn;
    _ftInController = FixedExtentScrollController(initialItem: selectedFtInIndex);
  }

  @override
  void dispose() {
    _cmController.dispose();
    _ftInController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Widget selectionOverlay = Container(
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: Color(0xFFE0E0E0), width: 1.0),
          bottom: BorderSide(color: Color(0xFFE0E0E0), width: 1.0),
        ),
      ),
    );

    return Obx(() {
      final isCm = controller.heightUnit.value == 'cm';
      
      if (isCm) {
        return SizedBox(
          height: 200,
          child: CupertinoPicker(
            itemExtent: 40,
            selectionOverlay: selectionOverlay,
            scrollController: _cmController,
            onSelectedItemChanged: (index) {
              setState(() {
                selectedCmIndex = index;
              });
              controller.heightCm.value = (100 + index).toString();
            },
            children: List.generate(
              150, // from 100cm to 249cm
              (index) {
                bool isSelected = selectedCmIndex == index;
                return Center(
                  child: Text(
                    '${100 + index} cm',
                    style: TextStyle(
                      fontSize: isSelected ? 24 : 22,
                      fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
                      color: isSelected ? Colors.black : Colors.grey[500],
                    ),
                  ),
                );
              },
            ),
          ),
        );
      } else {
        return SizedBox(
          height: 200,
          child: CupertinoPicker(
            itemExtent: 40,
            selectionOverlay: selectionOverlay,
            scrollController: _ftInController,
            onSelectedItemChanged: (index) {
              setState(() {
                selectedFtInIndex = index;
              });
              int ft = 4 + (index ~/ 12);
              int inch = index % 12;
              controller.heightFt.value = ft.toString();
              controller.heightIn.value = inch.toString();
            },
            children: List.generate(
              48, // from 4ft 0in to 7ft 11in
              (index) {
                bool isSelected = selectedFtInIndex == index;
                int ft = 4 + (index ~/ 12);
                int inch = index % 12;
                return Center(
                  child: Text(
                    '$ft ft $inch in',
                    style: TextStyle(
                      fontSize: isSelected ? 24 : 22,
                      fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
                      color: isSelected ? Colors.black : Colors.grey[500],
                    ),
                  ),
                );
              },
            ),
          ),
        );
      }
    });
  }
}
