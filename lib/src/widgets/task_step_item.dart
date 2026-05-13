import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TaskStepItem extends StatelessWidget {
  final String text;
  final bool isCompleted;
  final VoidCallback? onToggle;
  final VoidCallback? onDelete;

  const TaskStepItem({
    super.key,
    required this.text,
    this.isCompleted = false,
    this.onToggle,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Row(
        children: [
          const Icon(Icons.drag_indicator, color: Colors.black26),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onToggle,
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isCompleted ? const Color(0xFF6C63FF) : Colors.black26,
                  width: 2,
                ),
                color: isCompleted ? const Color(0xFF6C63FF) : Colors.transparent,
              ),
              child: isCompleted
                  ? const Icon(Icons.check, size: 16, color: Colors.white)
                  : null,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: isCompleted ? Colors.black38 : Colors.black87,
                decoration: isCompleted ? TextDecoration.lineThrough : null,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.black38, size: 20),
            onPressed: onDelete,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}
