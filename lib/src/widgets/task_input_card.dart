import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_button.dart';

class TaskInputCard extends StatefulWidget {
  final Function(String) onAddTask;

  const TaskInputCard({super.key, required this.onAddTask});

  @override
  State<TaskInputCard> createState() => _TaskInputCardState();
}

class _TaskInputCardState extends State<TaskInputCard> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFE8E6FF).withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF6C63FF).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.check_box_outlined,
                  color: Color(0xFF6C63FF),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'O que você precisa fazer agora?',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _controller,
            decoration: InputDecoration(
              hintText: 'Digite sua tarefa...',
              hintStyle: GoogleFonts.poppins(color: Colors.black26),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              suffixIcon: const Icon(Icons.add, color: Colors.black26),
            ),
          ),
          const SizedBox(height: 16),
          AppButton(
            text: 'Quebrar em passos',
            icon: Icons.chevron_right,
            iconAtEnd: true,
            borderRadius: 16,
            onPressed: () {
              final text = _controller.text.trim();
              widget.onAddTask(text);
              if (text.isNotEmpty) {
                _controller.clear();
              }
            },
          ),
        ],
      ),
    );
  }
}
