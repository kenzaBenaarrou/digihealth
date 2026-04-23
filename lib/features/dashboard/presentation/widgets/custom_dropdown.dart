import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomDropdown extends StatefulWidget {
  final String selectedValue;
  final Function(String) onChanged;
  final List<String> options;
  final double? width;

  const CustomDropdown({
    super.key,
    required this.selectedValue,
    required this.onChanged,
    this.options = const ['Moyenne', 'Somme'],
    this.width,
  });

  @override
  State<CustomDropdown> createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Main Button
        GestureDetector(
          onTap: () {
            setState(() => _isExpanded = !_isExpanded);
          },
          child: Container(
            width: widget.width ?? 75.w,
            padding:
                EdgeInsets.only(left: 10.w, right: 1.w, top: 5.h, bottom: 5.h),
            decoration: BoxDecoration(
              color: const Color(0xFF0A1F38),
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(
                color: Colors.cyanAccent.withOpacity(0.3),
                width: 1.2,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.selectedValue,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 9.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Icon(
                  _isExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: Colors.cyanAccent,
                  size: 12.sp,
                ),
              ],
            ),
          ),
        ),

        // Dropdown Menu
        if (_isExpanded)
          Container(
            width: widget.width ?? 75.w,
            margin: EdgeInsets.only(top: 4.h),
            decoration: BoxDecoration(
              color: const Color(0xFF0A1F38),
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(
                color: Colors.cyanAccent.withOpacity(0.3),
                width: 1.2,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widget.options.map((option) {
                final isSelected = option == widget.selectedValue;
                return GestureDetector(
                  onTap: () {
                    widget.onChanged(option);
                    setState(() => _isExpanded = false);
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 4.h),
                    padding:
                        EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.cyanAccent.withOpacity(0.15)
                          : null,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      option,
                      style: TextStyle(
                        color: isSelected ? Colors.cyanAccent : Colors.white,
                        fontSize: 9.sp,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }
}
