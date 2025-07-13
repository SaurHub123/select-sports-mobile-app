import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:select_sports/core/constants/theme_constants.dart';
import 'package:select_sports/providers/theme_provider.dart';

class CustomTextFields {
  // Outlined TextField with theme integration from ThemeProvider
  static Widget outlined({
    required TextEditingController controller,
    String? hintText,
    String? labelText,
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    int maxLines = 1,
    bool enabled = true,
    required WidgetRef ref,
    Function()? onClick,
    int? maxLength,
  }) {
    FocusNode fieldFocus = FocusNode();
    bool hasError = false;
    final isDarkMode = ref.watch(themeProvider) == ThemeMode.dark;

    return StatefulBuilder(builder: (context, setState) {
      fieldFocus.addListener(() {
        setState(() {});
      });

      return GestureDetector(
        onTap: onClick,
        child: AbsorbPointer(
          absorbing: onClick != null,
          child: TextFormField(
            focusNode: fieldFocus,
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,
            enabled: enabled,
            validator: (value) {
              final result = validator?.call(value);
              setState(() {
                hasError = result != null;
              });
              return result;
            },
            maxLines: maxLines,
            maxLength: maxLength,
            cursorColor: isDarkMode
                ? AppColors.inputFilledBackground
                : AppColors.darkGreenColor,
            style: TextStyle(
              color: isDarkMode ? AppColors.lightGreyColor : AppColors.darkText,
            ),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(
                color: isDarkMode
                    ? AppColors.mediumGreyColor
                    : AppColors.darkGreenColor,
              ),
              labelText: labelText,
              labelStyle: TextStyle(
                color: hasError
                    ? Colors.red
                    : isDarkMode
                    ? fieldFocus.hasFocus
                        ? AppColors.lightGreenColor
                        : AppColors.lightGreyColor
                    : AppColors.darkGreenColor,
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: isDarkMode
                      ? AppColors.lightGreenColor
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
          ),
        ),
      );
    });
  }

  // Outlined TextField with Icon and theme integration from ThemeProvider
  static Widget outlinedWithIcon({
    required TextEditingController controller,
    String? hintText,
    String? labelText,
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    int maxLines = 1,
    required WidgetRef ref,
    required Icon icon,
    required VoidCallback onIconPressed,
    required bool isPrefix,
    EdgeInsetsGeometry? iconPadding,
  }) {
    FocusNode fieldFocus = FocusNode();
    bool hasError = false;
    final isDarkMode = ref.watch(themeProvider) == ThemeMode.dark;

    return StatefulBuilder(builder: (context, setState) {
      fieldFocus.addListener(() {
        setState(() {});
      });

      return TextFormField(
        focusNode: fieldFocus,
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        validator: (value) {
          final result = validator?.call(value);
          setState(() {
            hasError = result != null;
          });
          return result;
        },
        maxLines: maxLines,
        style: TextStyle(
          color: isDarkMode ? AppColors.lightText : AppColors.darkText,
        ),
        cursorColor: AppColors.darkGreenColor,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: isDarkMode
                ? AppColors.mediumGreyColor
                : AppColors.darkGreenColor,
          ),
          labelText: labelText,
          labelStyle: TextStyle(
            color: hasError
                ? Colors.red
                : isDarkMode
                ? fieldFocus.hasFocus
                    ? AppColors.lightGreenColor
                    : AppColors.lightGreyColor
                : AppColors.darkGreenColor,
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: isDarkMode
                  ? AppColors.lightGreenColor
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
          prefixIcon: isPrefix // Add prefix/postfix logic
              ? Padding(
                  padding:
                      iconPadding ?? EdgeInsets.zero, // Add padding if provided
                  child: IconButton(
                    icon: icon,
                    onPressed: onIconPressed,
                  ),
                )
              : null,
          suffixIcon: !isPrefix // Add postfix logic
              ? Padding(
                  padding:
                      iconPadding ?? EdgeInsets.zero, // Add padding if provided
                  child: IconButton(
                    icon: icon,
                    onPressed: onIconPressed,
                  ),
                )
              : null,
        ),
      );
    });
  }
}
