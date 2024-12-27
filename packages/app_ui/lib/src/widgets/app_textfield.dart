import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final String hintText;
  final TextStyle? hintStyle;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final bool isPassword;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixIconTap;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(bool hasError)? hasErrorCallback;
  const CustomTextField({
    super.key,
    required this.hintText,
    this.controller,
    this.hintStyle,
    this.keyboardType = TextInputType.text,
    this.isPassword = false,
    this.suffixIcon,
    this.onSuffixIconTap,
    this.validator,
    this.onChanged,
    this.hasErrorCallback
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true; // Default value for obscureText
  String? _errorMessage; // Holds the validation error message
  bool hasError() {
    return _errorMessage != null && _errorMessage!.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                spreadRadius: 2,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: TextFormField(
            controller: widget.controller,
            keyboardType: widget.keyboardType,
            obscureText: widget.isPassword ? _obscureText : false,
            validator: (value) {
              final validationResult = widget.validator?.call(value);
              setState(() {
                _errorMessage = validationResult; // Update the error message
              });
              widget.hasErrorCallback?.call(hasError());
              return null;
            },
            onChanged: widget.onChanged,
            decoration: InputDecoration(
              hintStyle: widget.hintStyle ??
                  AppTextStyle.bodySmall400.copyWith(color: AppColors.blue),
              hintText: widget.hintText,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 16,
                horizontal: 25,
              ),
              border: InputBorder.none,
              suffixIcon: widget.isPassword
                  ? GestureDetector(
                      onTap: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                      child: Icon(
                        _obscureText ? Icons.visibility_off : Icons.visibility,
                        color: AppColors.greyishBlue,
                      ),
                    )
                  : widget.suffixIcon != null
                      ? GestureDetector(
                          onTap: widget.onSuffixIconTap,
                          child: Icon(widget.suffixIcon,
                              color: AppColors.greyishBlue),
                        )
                      : null,
            ),
          ),
        ),
        if (hasError())
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              _errorMessage!,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }
}
