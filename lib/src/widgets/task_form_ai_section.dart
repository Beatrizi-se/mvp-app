import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_button.dart';

class TaskFormAISection extends StatelessWidget {
  final bool useAI;
  final ValueChanged<bool> onToggleAI;
  final VoidCallback onGenerateSteps;

  const TaskFormAISection({
    super.key,
    required this.useAI,
    required this.onToggleAI,
    required this.onGenerateSteps,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Quebrar em passos com IA',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(width: 8),
                      _buildBadge('Novo'),
                    ],
                  ),
                  const Text(
                    'Nossa IA divide sua tarefa em passos menores e mais fáceis de começar.',
                    style: TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                ],
              ),
            ),
            Switch(
              value: useAI,
              onChanged: onToggleAI,
              activeColor: const Color(0xFF6C63FF),
            ),
          ],
        ),
        if (useAI) ...[
          const SizedBox(height: 16),
          _buildAIBanner(),
        ],
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

  Widget _buildAIBanner() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF0EFFF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF6C63FF).withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.auto_awesome, color: Color(0xFF6C63FF), size: 20),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'A IA vai sugerir passos para essa tarefa.',
                  style: TextStyle(fontSize: 11, color: Colors.black87),
                ),
                Text(
                  'Você poderá editar ou remover os passos depois.',
                  style: TextStyle(fontSize: 11, color: Colors.black54),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          AppButton(
            text: 'Gerar',
            width: 90,
            height: 36,
            borderRadius: 10,
            fontSize: 12,
            padding: EdgeInsets.zero,
            onPressed: onGenerateSteps,
            icon: Icons.auto_awesome,
            textColor: Colors.white,
          ),
        ],
      ),
    );
  }
}
