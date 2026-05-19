import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DuckTipCard extends StatelessWidget {
  final String title;
  final String tip;
  final String? secondaryTip;
  final Color? backgroundColor;
  final Widget? leading;
  final Widget? trailing;

  const DuckTipCard({
    super.key,
    this.title = 'Dica do Pato 💜',
    required this.tip,
    this.secondaryTip,
    this.backgroundColor,
    this.leading,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: backgroundColor ?? const Color(0xFFFFF7E8),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFFFECB3).withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          leading ?? Image.asset(
            'assets/pato_muito_feliz_image.png',
            height: 45,
            width: 45,
            fit: BoxFit.contain,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF07143F),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  tip,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: const Color(0xFF56617A),
                    height: 1.4,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (secondaryTip != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    secondaryTip!,
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: theme.colorScheme.primary,
                      height: 1.3,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ]
              ],
            ),
          ),
          const SizedBox(width: 8),
          trailing ?? CircleAvatar(
            radius: 18,
            backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.1),
            child: Icon(
              Icons.lightbulb_outline_rounded,
              color: theme.colorScheme.primary,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}
