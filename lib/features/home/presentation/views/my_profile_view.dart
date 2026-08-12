import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/snackbar_util.dart';
import '../../../onboarding/presentation/widgets/custom_date_picker.dart';
import '../../../onboarding/presentation/widgets/horizontal_ruler_slider.dart';
import 'package:fitness_app/core/widgets/custom_back_button.dart';

class MyProfileView extends StatefulWidget {
  const MyProfileView({super.key});

  @override
  State<MyProfileView> createState() => _MyProfileViewState();
}

class _MyProfileViewState extends State<MyProfileView> {
  DateTime? dob;
  String height = '170 cm';
  String weight = '75 kg';
  String? gender;
  
  Widget _buildBottomSheetContainer({required Widget child}) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(4),
          topRight: Radius.circular(4),
        ),
      ),
      padding: EdgeInsets.only(
        top: 12,
        left: 24,
        right: 24,
        bottom: MediaQuery.of(context).padding.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 48,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  void _showCameraBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return _buildBottomSheetContainer(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Select Profile Picture',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDobBottomSheet() {
    DateTime tempDate = dob ?? DateTime(1996, 6, 15);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateModal) {
            return _buildBottomSheetContainer(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Select Date of Birth',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 200,
                    child: CustomDatePicker(
                      initialDate: tempDate,
                      onDateChanged: (DateTime newDate) {
                        setStateModal(() {
                          tempDate = newDate;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        dob = tempDate;
                      });
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.black,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    child: const Text(
                      'Apply',
                      style: TextStyle(
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showHeightBottomSheet() {
    bool isCm = height.contains('cm');
    int tempCm = isCm ? (int.tryParse(height.split(' ').first) ?? 170) : 170;
    int tempFt = 5;
    int tempIn = 9;
    if (!isCm) {
      final parts = height.split(' ');
      if (parts.length >= 3) {
        tempFt = int.tryParse(parts[0]) ?? 5;
        tempIn = int.tryParse(parts[2]) ?? 9;
      }
    }

    final Widget selectionOverlay = Container(
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: Color(0xFFE0E0E0), width: 1.0),
          bottom: BorderSide(color: Color(0xFFE0E0E0), width: 1.0),
        ),
      ),
    );

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateModal) {
            return _buildBottomSheetContainer(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Select Height',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: CupertinoSlidingSegmentedControl<bool>(
                      backgroundColor: Colors.grey[200]!,
                      thumbColor: Colors.white,
                      groupValue: isCm,
                      children: {
                        false: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          child: Text(
                            'Feet and Inches',
                            style: TextStyle(
                              color: !isCm ? Colors.black : Colors.grey[700],
                              fontWeight: !isCm ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ),
                        true: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          child: Text(
                            'Centimeters',
                            style: TextStyle(
                              color: isCm ? Colors.black : Colors.grey[700],
                              fontWeight: isCm ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ),
                      },
                      onValueChanged: (value) {
                        if (value != null) {
                          setStateModal(() {
                            isCm = value;
                          });
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 200,
                    child: isCm
                        ? CupertinoPicker(
                            itemExtent: 40,
                            selectionOverlay: selectionOverlay,
                            scrollController: FixedExtentScrollController(initialItem: tempCm - 100),
                            onSelectedItemChanged: (index) {
                              setStateModal(() {
                                tempCm = 100 + index;
                              });
                            },
                            children: List.generate(
                              150,
                              (index) {
                                bool isSelected = tempCm == (100 + index);
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
                          )
                        : CupertinoPicker(
                            itemExtent: 40,
                            selectionOverlay: selectionOverlay,
                            scrollController: FixedExtentScrollController(initialItem: ((tempFt - 4) * 12) + tempIn),
                            onSelectedItemChanged: (index) {
                              setStateModal(() {
                                tempFt = 4 + (index ~/ 12);
                                tempIn = index % 12;
                              });
                            },
                            children: List.generate(
                              48, // 4ft to 7ft 11in
                              (index) {
                                int ft = 4 + (index ~/ 12);
                                int inch = index % 12;
                                bool isSelected = tempFt == ft && tempIn == inch;
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
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        height = isCm ? '$tempCm cm' : '$tempFt ft $tempIn in';
                      });
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.black,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    child: const Text(
                      'Apply',
                      style: TextStyle(
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showWeightBottomSheet() {
    bool isKg = weight.contains('kg');
    int tempKg = isKg ? (int.tryParse(weight.split(' ').first) ?? 75) : 75;
    int tempLbs = !isKg ? (int.tryParse(weight.split(' ').first) ?? 165) : 165;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateModal) {
            return _buildBottomSheetContainer(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Select Weight',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: CupertinoSlidingSegmentedControl<bool>(
                      backgroundColor: Colors.grey[200]!,
                      thumbColor: Colors.white,
                      groupValue: isKg,
                      children: {
                        false: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          child: Text(
                            'Pounds',
                            style: TextStyle(
                              color: !isKg ? Colors.black : Colors.grey[700],
                              fontWeight: !isKg ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ),
                        true: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          child: Text(
                            'Kilograms',
                            style: TextStyle(
                              color: isKg ? Colors.black : Colors.grey[700],
                              fontWeight: isKg ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ),
                      },
                      onValueChanged: (value) {
                        if (value != null) {
                          setStateModal(() {
                            isKg = value;
                          });
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    isKg ? '$tempKg kg' : '$tempLbs lbs',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: SizedBox(
                      height: 100,
                      child: HorizontalRulerSlider(
                        key: ValueKey(isKg),
                        min: isKg ? 30 : 60,
                        max: isKg ? 200 : 400,
                        initialValue: isKg ? tempKg : tempLbs,
                        onChanged: (val) {
                          setStateModal(() {
                            if (isKg) {
                              tempKg = val;
                            } else {
                              tempLbs = val;
                            }
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        weight = isKg ? '$tempKg kg' : '$tempLbs lbs';
                      });
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.black,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    child: const Text(
                      'Apply',
                      style: TextStyle(
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0,vertical: 8),
          child: ElevatedButton(
            onPressed: () {
              Get.back();
              SnackbarUtil.showSuccess(
                title: 'Success',
                message: 'Profile updated successfully',
              );
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Text('UPDATE'),
            ),
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: AppColors.black,
            elevation: 0,
            toolbarHeight: 60,
            centerTitle: true,
            leading: const CustomBackButton(color: AppColors.white),
            iconTheme: const IconThemeData(color: AppColors.white),
            title: const Text(
              'MY PROFILE',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 18,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.5,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                _buildHeader(),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 24.0,
                    right: 24.0,
                    top: 24.0,
                    bottom: 24.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Row(
                        children: [
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                labelText: 'First Name',
                              ),
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                labelText: 'Last Name',
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const TextField(
                        decoration: InputDecoration(
                          labelText: 'Email',
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 16),
                      const TextField(
                        decoration: InputDecoration(
                          labelText: 'Phone Number',
                        ),
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: 'Gender',
                        ),
                        value: gender,
                        items: ['Male', 'Female', 'Non-binary', 'Prefer not to say']
                            .map((label) => DropdownMenuItem(
                                  value: label,
                                  child: Text(label),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            gender = value;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      GestureDetector(
                        onTap: _showDobBottomSheet,
                        child: AbsorbPointer(
                          child: TextField(
                            controller: TextEditingController(
                              text: dob != null ? '${dob!.day}/${dob!.month}/${dob!.year}' : '',
                            ),
                            decoration: const InputDecoration(
                              labelText: 'Date of Birth',
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: _showHeightBottomSheet,
                              child: AbsorbPointer(
                                child: TextField(
                                  controller: TextEditingController(text: height),
                                  decoration: const InputDecoration(
                                    labelText: 'Height',
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: GestureDetector(
                              onTap: _showWeightBottomSheet,
                              child: AbsorbPointer(
                                child: TextField(
                                  controller: TextEditingController(text: weight),
                                  decoration: const InputDecoration(
                                    labelText: 'Weight',
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      color: AppColors.black,
      child: Container(
        height: 220,
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: _showCameraBottomSheet,
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.white, width: 2),
                      image: const DecorationImage(
                        image: NetworkImage('https://i.pravatar.cc/300?img=11'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: AppColors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      size: 20,
                      color: AppColors.black,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
