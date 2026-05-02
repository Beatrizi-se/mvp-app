import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DuckTipCard extends StatelessWidget {
  final String tip;

  const DuckTipCard({super.key, required this.tip});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7E1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(Icons.sentiment_satisfied_alt, size: 40, color: Color(0xFFFFD862)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Dica do Pato',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.favorite, size: 14, color: Color(0xFF6C63FF)),
                  ],
                ),
                Text(
                  tip,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
