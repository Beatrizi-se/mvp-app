import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextField extends StatefulWidget {
  final String label;
  final String hintText;
  final TextEditingController? controller;
  final IconData? suffixIcon;
  final IconData? icon;
  final bool isPassword;
  final int maxLines;
  final int? maxLength;
  final ValueChanged<String>? onChanged;
  final TextInputType? keyboardType;

  const AppTextField({
    super.key,
    required this.label,
    required this.hintText,
    this.controller,
    this.suffixIcon,
    this.icon,
    this.isPassword = false,
    this.maxLines = 1,
    this.maxLength,
    this.onChanged,
    this.keyboardType,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.label,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
            if (widget.maxLength != null && widget.controller != null)
              ValueListenableBuilder(
                valueListenable: widget.controller!,
                builder: (context, value, child) {
                  return Text(
                    "${value.text.length}/${widget.maxLength}",
                    style: const TextStyle(fontSize: 10, color: Colors.black26),
                  );
                },
              ),
          ],
        ),
        const SizedBox(height: 8),
        TextField(
          controller: widget.controller,
          obscureText: _obscureText,
          maxLines: widget.maxLines,
          maxLength: widget.maxLength,
          onChanged: widget.onChanged,
          keyboardType: widget.keyboardType,
          style: GoogleFonts.poppins(fontSize: 14),
          decoration: InputDecoration(
            prefixIcon: widget.icon != null ? Icon(widget.icon, color: Colors.black38, size: 20) : null,
            hintText: widget.hintText,
            hintStyle: GoogleFonts.poppins(color: Colors.black26, fontSize: 14),
            filled: true,
            fillColor: Colors.white,
            counterText: "", // Esconde o contador padrão do Material
            suffixIcon: widget.isPassword
                ? IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                      color: Colors.black38,
                      size: 20,
                    ),
                    onPressed: () => setState(() => _obscureText = !_obscureText),
                  )
                : widget.suffixIcon != null
                    ? Icon(widget.suffixIcon, color: Colors.black38, size: 20)
                    : null,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}
