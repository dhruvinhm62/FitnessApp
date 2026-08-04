import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomDatePicker extends StatefulWidget {
  final DateTime initialDate;
  final ValueChanged<DateTime> onDateChanged;

  const CustomDatePicker({
    super.key,
    required this.initialDate,
    required this.onDateChanged,
  });

  @override
  State<CustomDatePicker> createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  late int selectedMonth;
  late int selectedDay;
  late int selectedYear;

  late FixedExtentScrollController _dayController;
  late FixedExtentScrollController _monthController;
  late FixedExtentScrollController _yearController;

  static const List<String> months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];
  final int minYear = 1900;
  final int maxYear = DateTime.now().year;

  @override
  void initState() {
    super.initState();
    selectedMonth = widget.initialDate.month;
    selectedDay = widget.initialDate.day;
    selectedYear = widget.initialDate.year;

    _dayController = FixedExtentScrollController(initialItem: selectedDay - 1);
    _monthController = FixedExtentScrollController(initialItem: selectedMonth - 1);
    _yearController = FixedExtentScrollController(initialItem: selectedYear - minYear);
  }

  @override
  void dispose() {
    _dayController.dispose();
    _monthController.dispose();
    _yearController.dispose();
    super.dispose();
  }

  int getDaysInMonth(int year, int month) {
    return DateTime(year, month + 1, 0).day;
  }

  void updateDate() {
    int maxDays = getDaysInMonth(selectedYear, selectedMonth);
    if (selectedDay > maxDays) {
      selectedDay = maxDays;
      if (_dayController.hasClients) {
        _dayController.jumpToItem(selectedDay - 1);
      }
    }
    widget.onDateChanged(DateTime(selectedYear, selectedMonth, selectedDay));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    int maxDays = getDaysInMonth(selectedYear, selectedMonth);

    // Custom selection overlay with top and bottom borders
    final Widget selectionOverlay = Container(
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: Color(0xFFE0E0E0), width: 1.0),
          bottom: BorderSide(color: Color(0xFFE0E0E0), width: 1.0),
        ),
      ),
    );

    return Row(
      children: [
        // Month
        Expanded(
          flex: 4,
          child: CupertinoPicker(
            itemExtent: 40,
            selectionOverlay: selectionOverlay,
            scrollController: _monthController,
            onSelectedItemChanged: (index) {
              selectedMonth = index + 1;
              updateDate();
            },
            children: List.generate(12, (index) {
              bool isSelected = (index + 1) == selectedMonth;
              return Center(
                child: Text(
                  months[index],
                  style: TextStyle(
                    fontSize: isSelected ? 22 : 20,
                    fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
                    color: isSelected ? Colors.black : Colors.grey[500],
                  ),
                ),
              );
            }),
          ),
        ),
        // Day
        Expanded(
          flex: 3,
          child: CupertinoPicker(
            itemExtent: 40,
            selectionOverlay: selectionOverlay,
            scrollController: _dayController,
            onSelectedItemChanged: (index) {
              selectedDay = index + 1;
              updateDate();
            },
            children: List.generate(maxDays, (index) {
              bool isSelected = (index + 1) == selectedDay;
              return Center(
                child: Text(
                  '${index + 1}',
                  style: TextStyle(
                    fontSize: isSelected ? 22 : 20,
                    fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
                    color: isSelected ? Colors.black : Colors.grey[500],
                  ),
                ),
              );
            }),
          ),
        ),
        // Year
        Expanded(
          flex: 4,
          child: CupertinoPicker(
            itemExtent: 40,
            selectionOverlay: selectionOverlay,
            scrollController: _yearController,
            onSelectedItemChanged: (index) {
              selectedYear = minYear + index;
              updateDate();
            },
            children: List.generate(maxYear - minYear + 1, (index) {
              int year = minYear + index;
              bool isSelected = year == selectedYear;
              return Center(
                child: Text(
                  '$year',
                  style: TextStyle(
                    fontSize: isSelected ? 22 : 20,
                    fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
                    color: isSelected ? Colors.black : Colors.grey[500],
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}
