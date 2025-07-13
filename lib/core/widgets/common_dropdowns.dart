import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:select_sports/core/constants/theme_constants.dart';
import 'package:select_sports/providers/theme_provider.dart';

class CommonDropdown extends ConsumerStatefulWidget {
  final List<String> items;
  final String? selectedValue;
  final ValueChanged<String?> onChanged;

  const CommonDropdown({
    super.key,
    required this.items,
    required this.selectedValue,
    required this.onChanged,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CommonDropdownState();
}

class _CommonDropdownState extends ConsumerState<CommonDropdown> {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(themeProvider) == ThemeMode.dark;

    return SizedBox(
      width: 90.w,
      height: 55,
      child: ButtonTheme(
        // alignedDropdown: true,
        child: DropdownButtonFormField<String>(
          value: widget.selectedValue,
          onChanged: widget.onChanged,
          dropdownColor: isDarkMode ? Colors.grey[900] : Colors.white,
          icon: Icon(
            Icons.arrow_drop_down,
            color:
                isDarkMode ? AppColors.mediumGreyColor : AppColors.darkGreenColor,
          ),
          decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: isDarkMode
                    ? AppColors.mediumGreyColor
                    : AppColors.darkGreenColor,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: isDarkMode
                    ? AppColors.mediumGreyColor
                    : AppColors.darkGreenColor,
              ),
            ),
            border: OutlineInputBorder(),
          ),
          hint: Text(
            'Select option',
            style: AppTextStyles.body.copyWith(
              color: isDarkMode
                  ? AppColors.lightGreyColor
                  : AppColors.mediumGreyColor,
            ),
          ),
          style: TextStyle(
            color:
                isDarkMode ? AppColors.mediumGreyColor : AppColors.darkGreenColor,
          ),
          items: widget.items.map(
            (String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: AppTextStyles.body.copyWith(
                    color: isDarkMode
                        ? AppColors.lightGreyColor
                        : AppColors.darkGreenColor,
                  ),
                ),
              );
            },
          ).toList(),
        ),
      ),
    );
  }
}
