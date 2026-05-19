import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../models/task_step_model.dart';

class TaskOverviewStepItem extends StatelessWidget {
  final int index;
  final TaskStep step;
  final Color primaryColor;
  final bool isNext;
  final VoidCallback onStart;
  final VoidCallback onReview;

  const TaskOverviewStepItem({
    super.key,
    required this.index,
    required this.step,
    required this.primaryColor,
    required this.isNext,
    required this.onStart,
    required this.onReview,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isNext ? Colors.white : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isNext ? primaryColor.withValues(alpha: 0.3) : Colors.black.withValues(alpha: 0.05),
          width: isNext ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.drag_indicator, color: Colors.black12, size: 20),
          const SizedBox(width: 8),
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: step.isCompleted ? Colors.green : Colors.white,
              shape: BoxShape.circle,
              border: Border.all(
                color: step.isCompleted ? Colors.green : Colors.black26,
              ),
            ),
            child: step.isCompleted 
                ? const Icon(Icons.check, color: Colors.white, size: 16)
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${index + 1}. ${step.title}',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: isNext ? FontWeight.bold : FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  step.isCompleted 
                    ? 'Concluído em ${DateFormat('dd/MM').format(step.completedAt ?? DateTime.now())}' 
                    : (step.duration != null ? 'Aprox. ${step.duration}' : 'Pendente'),
                  style: GoogleFonts.poppins(fontSize: 12, color: Colors.black45),
                ),
              ],
            ),
          ),
          if (isNext)
            ElevatedButton(
              onPressed: onStart,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.play_arrow_rounded, size: 18),
                  const SizedBox(width: 4),
                  Text('Iniciar', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold)),
                ],
              ),
            )
          else if (step.isCompleted)
            TextButton(
              onPressed: onReview,
              child: Row(
                children: [
                  const Icon(Icons.refresh, size: 16, color: Colors.black45),
                  const SizedBox(width: 4),
                  Text('Revisar', style: GoogleFonts.poppins(fontSize: 12, color: Colors.black45)),
                ],
              ),
            )
          else
            const Icon(Icons.chevron_right, color: Colors.black26),
        ],
      ),
    );
  }
}
