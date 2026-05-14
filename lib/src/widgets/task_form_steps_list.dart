import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'task_step_item.dart';

class TaskFormStepsList extends StatelessWidget {
  final List<String> steps;
  final VoidCallback onAddStep;
  final Function(int) onDeleteStep;

  const TaskFormStepsList({
    super.key,
    required this.steps,
    required this.onAddStep,
    required this.onDeleteStep,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Passos da tarefa',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
            if (steps.isNotEmpty) ...[
              const SizedBox(width: 8),
              _buildBadge('${steps.length} passos'),
            ],
          ],
        ),
        const SizedBox(height: 16),
        if (steps.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text(
                'Nenhum passo adicionado ainda',
                style: GoogleFonts.poppins(color: Colors.black26),
              ),
            ),
          )
        else
          ...steps.asMap().entries.map((entry) => TaskStepItem(
                text: entry.value,
                onDelete: () => onDeleteStep(entry.key),
              )),
        TextButton.icon(
          onPressed: onAddStep,
          icon: const Icon(Icons.add, color: Color(0xFF6C63FF)),
          label: Text(
            'Adicionar passo manualmente',
            style: GoogleFonts.poppins(
              color: const Color(0xFF6C63FF),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0xFFE8E6FF),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFF6C63FF),
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
