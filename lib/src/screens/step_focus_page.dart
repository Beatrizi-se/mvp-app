import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/task_model.dart';
import '../widgets/app_header.dart';
import '../widgets/app_button.dart';

class StepFocusPage extends StatefulWidget {
  final TaskModel task;
  final int stepIndex;

  const StepFocusPage({
    super.key,
    required this.task,
    required this.stepIndex,
  });

  @override
  State<StepFocusPage> createState() => _StepFocusPageState();
}

class _StepFocusPageState extends State<StepFocusPage> {
  late bool _isCompleted;

  @override
  void initState() {
    super.initState();
    _isCompleted = widget.task.steps[widget.stepIndex].isCompleted;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final step = widget.task.steps[widget.stepIndex];

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppHeader(
        onLeadingPressed: () => Navigator.pop(context),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.psychology_outlined,
                  size: 80,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'Passo ${widget.stepIndex + 1}',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                step.title,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              if (step.duration != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.access_time, size: 16, color: Colors.black54),
                      const SizedBox(width: 4),
                      Text(
                        'Aprox. ${step.duration}',
                        style: GoogleFonts.poppins(fontSize: 12, color: Colors.black54),
                      ),
                    ],
                  ),
                ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      'Foque apenas neste passo agora.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 24),
                    AppButton(
                      text: _isCompleted ? 'Concluído! ✨' : 'Marcar como concluído',
                      onPressed: () {
                        setState(() {
                          _isCompleted = true;
                        });
                        // Aqui você chamaria o serviço para atualizar o status
                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Passo concluído com sucesso!')),
                        );
                        Future.delayed(const Duration(seconds: 1), () {
                          if (!context.mounted) return;
                          Navigator.pop(context, true);
                        });
                      },
                      type: _isCompleted ? AppButtonType.primary : AppButtonType.primary,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
