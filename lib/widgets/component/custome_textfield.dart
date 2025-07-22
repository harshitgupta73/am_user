import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final String? label;
  final String? hint;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final TextInputType inputType;
  final bool isPassword;
  final TextEditingController? controller;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final bool readOnly;
  final int maxLines;
  final double? fontSize;
  final Color? color;

  const CustomTextField({
    super.key,
    this.label,
    this.fontSize,
    this.hint,
    this.prefixIcon,
    this.suffixIcon,
    this.inputType = TextInputType.text,
    this.isPassword = false,
    this.controller,
    this.onChanged,
    this.validator,
    this.readOnly = false,
    this.maxLines = 1,
    this.color
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: TextStyle(color: widget.color,fontSize: widget.fontSize),
      controller: widget.controller,
      keyboardType: widget.inputType,
      obscureText: widget.isPassword ? _obscureText : false,
      onChanged: widget.onChanged,
      validator: widget.validator,
      readOnly: widget.readOnly,
      maxLines: widget.isPassword ? 1 : widget.maxLines,

      decoration: InputDecoration(
        labelText: widget.label,
        labelStyle: TextStyle(color: widget.color),
        hintText: widget.hint,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey), // Default color
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey), // 👈 Same color when focused
        ),
        prefixIcon: widget.prefixIcon != null
            ? Icon(widget.prefixIcon)
            : null,
        suffixIcon: widget.isPassword
            ? IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility_off : Icons.visibility,
          ),
          onPressed: () {
            setState(() => _obscureText = !_obscureText);
          },
        )
            : widget.suffixIcon != null
            ? Icon(widget.suffixIcon)
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),

        ),
      ),
    );
  }
}
