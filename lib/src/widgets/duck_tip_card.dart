import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DuckTipCard extends StatelessWidget {
  final String title;
  final String tip;
  final String? secondaryTip;
  final Color backgroundColor;
  final Widget? leading;
  final Widget? trailing;

  const DuckTipCard({
    super.key,
    this.title = 'Dica do Pato',
    required this.tip,
    this.secondaryTip,
    this.backgroundColor = const Color(0xFFFFF7E1),
    this.leading,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          leading ?? const Icon(Icons.sentiment_satisfied_alt, size: 40, color: Color(0xFFFFD862)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF07143F),
                      ),
                    ),
                    if (trailing == null) ...[
                      const SizedBox(width: 4),
                      const Icon(Icons.favorite, size: 14, color: Color(0xFF6C63FF)),
                    ]
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  tip,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: const Color(0xFF56617A),
                    height: 1.3,
                  ),
                ),
                if (secondaryTip != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    secondaryTip!,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: const Color(0xFF56617A),
                      height: 1.3,
                    ),
                  ),
                ]
              ],
            ),
          ),
          if (trailing != null) ...[
            const SizedBox(width: 8),
            trailing!,
          ]
        ],
      ),
    );
  }
}
