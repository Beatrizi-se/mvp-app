import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TaskFormSelectorField extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color? iconColor;
  final VoidCallback onTap;

  const TaskFormSelectorField({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    bool isPlaceholder = value == 'Selecionar' || value == 'Definir data' || value == 'Definir horário';

    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE0E0E0)),
            ),
            child: Row(
              children: [
                Icon(icon, size: 20, color: iconColor ?? const Color(0xFF6C63FF)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    value,
                    style: GoogleFonts.poppins(
                      fontSize: 14, 
                      color: isPlaceholder ? Colors.black26 : Colors.black87,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Icon(Icons.keyboard_arrow_down, size: 20, color: Colors.black26),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
