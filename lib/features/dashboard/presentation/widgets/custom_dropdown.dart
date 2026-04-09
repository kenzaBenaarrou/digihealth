import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomDropdown extends StatefulWidget {
  final String selectedValue;
  final Function(String) onChanged;

  const CustomDropdown({
    super.key,
    required this.selectedValue,
    required this.onChanged,
  });

  @override
  State<CustomDropdown> createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  bool _isExpanded = false;

  final List<String> _options = ['Moyenne', 'Somme'];

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
            width: 90.w,
            padding:
                EdgeInsets.only(left: 14.w, right: 5.w, top: 5.h, bottom: 5.h),
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
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Icon(
                  _isExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: Colors.cyanAccent,
                  size: 14.sp,
                ),
              ],
            ),
          ),
        ),

        // Dropdown Menu
        if (_isExpanded)
          Container(
            width: 90.w,
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
              children: _options.map((option) {
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
                        fontSize: 12.sp,
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
