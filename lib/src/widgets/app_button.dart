import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum AppButtonType { primary, outlined, ghost }

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final IconData? icon;
  final Widget? leftIcon;
  final AppButtonType type;
  final Color? color;
  final Color? textColor;
  final double borderRadius;
  final double? height;
  final double? width;
  final bool isLoading;
  final bool iconAtEnd;
  final double? fontSize;
  final EdgeInsetsGeometry? padding;

  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.leftIcon,
    this.type = AppButtonType.primary,
    this.color,
    this.textColor,
    this.borderRadius = 25,
    this.height = 50,
    this.width = double.infinity,
    this.isLoading = false,
    this.iconAtEnd = false,
    this.fontSize,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = color ?? theme.colorScheme.primary;

    switch (type) {
      case AppButtonType.outlined:
        return _buildOutlinedButton(primaryColor);
      case AppButtonType.ghost:
        return _buildGhostButton(primaryColor);
      case AppButtonType.primary:
      
        return _buildElevatedButton(primaryColor);
    }
  }

  Widget _buildElevatedButton(Color primaryColor) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: textColor ?? Colors.white,
          elevation: 0,
          padding: padding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        child: _buildButtonContent(),
      ),
    );
  }

  Widget _buildOutlinedButton(Color primaryColor) {
    return SizedBox(
      width: width,
      height: height,
      child: OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: textColor ?? primaryColor,
          side: BorderSide(color: color ?? const Color(0xFFE0E0E0)),
          padding: padding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        child: _buildButtonContent(),
      ),
    );
  }

  Widget _buildGhostButton(Color primaryColor) {
    return SizedBox(
      width: width,
      height: height,
      child: TextButton(
        onPressed: isLoading ? null : onPressed,
        style: TextButton.styleFrom(
          foregroundColor: textColor ?? primaryColor,
          padding: padding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        child: _buildButtonContent(),
      ),
    );
  }

  Widget _buildButtonContent() {
    if (isLoading) {
      return const SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (leftIcon != null && !iconAtEnd) ...[
          leftIcon!,
          const SizedBox(width: 8),
        ],
        if (icon != null && !iconAtEnd) ...[
          Icon(icon, size: fontSize != null ? fontSize! + 4 : 20),
          const SizedBox(width: 8),
        ],
        Flexible(
          child: Text(
            text,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.poppins(
              fontSize: fontSize ?? 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        if (icon != null && iconAtEnd) ...[
          const SizedBox(width: 8),
          Icon(icon, size: fontSize != null ? fontSize! + 4 : 20),
        ],
      ],
    );
  }
}
