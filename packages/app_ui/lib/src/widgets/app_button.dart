import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.backgroundColor,
    this.textColor,
    this.borderRadius,
    this.isHomeAppBar = false,
    this.isAddTask = false,
    this.suffixIconEnable,
  });

  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool isHomeAppBar;
  final bool isAddTask;
  final double? borderRadius;
  final Color? backgroundColor;
  final Color? textColor;
  final bool? suffixIconEnable; // New parameter for suffix icon

  @override
  Widget build(BuildContext context) {
    return SizedBox( 
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.lightGrey.withOpacity(0.8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 5),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 23, vertical: 5), // Adjust padding
        ),
        child: isLoading
            ? const CircularProgressIndicator(
                color: Colors.white,
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    text,
                    style: AppTextStyle.heading.copyWith(
                      color: textColor ?? AppColors.blue,
                      fontWeight: FontWeight.w700,
                      fontSize: 18, // Adjust font size
                    ),
                  ),
                  if (suffixIconEnable == true) ...[
                    const SizedBox(width: 8), // Space between text and icon
                    const Icon(
                      Icons.arrow_forward,
                      color: Colors.black,
                      size: 20,
                    ),
                  ],
                ],
              ),
      ),
    );
  }
}
