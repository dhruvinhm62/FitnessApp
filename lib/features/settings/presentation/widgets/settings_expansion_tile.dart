import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';

class SettingsExpansionTile extends StatefulWidget {
  final String title;
  final List<String>? options;
  final List<String>? optionLabels;
  final String? selectedOption;
  final ValueChanged<String>? onChanged;
  final Widget? customExpandedChild;

  const SettingsExpansionTile({
    super.key,
    required this.title,
    this.options,
    this.optionLabels,
    this.selectedOption,
    this.onChanged,
    this.customExpandedChild,
  });

  @override
  State<SettingsExpansionTile> createState() => _SettingsExpansionTileState();
}

class _SettingsExpansionTileState extends State<SettingsExpansionTile> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        InkWell(
          onTap: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.black,
                      ),
                    ),
                    Icon(
                      _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                      color: AppColors.black,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        if (_isExpanded)
          if (widget.customExpandedChild != null)
            widget.customExpandedChild!
          else if (widget.options != null && widget.optionLabels != null && widget.selectedOption != null && widget.onChanged != null)
            ...widget.options!.asMap().entries.map((entry) {
              int idx = entry.key;
              String option = entry.value;
              String label = widget.optionLabels![idx];
              bool isSelected = widget.selectedOption == option;

              return GestureDetector(
                onTap: () {
                  widget.onChanged!(option);
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: const BoxDecoration(
                          color: AppColors.black,
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          label,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          option,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isSelected ? AppColors.black : Colors.transparent,
                          border: Border.all(
                            color: isSelected ? AppColors.black : Colors.grey[400]!,
                            width: isSelected ? 0 : 1,
                            style: isSelected ? BorderStyle.none : BorderStyle.solid,
                          ),
                        ),
                        child: isSelected
                            ? const Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 16,
                              )
                            : null,
                      ),
                    ],
                  ),
                ),
              );
            }),
        const Divider(height: 1, color: Color(0xFFE0E0E0)),
      ],
    );
  }
}
