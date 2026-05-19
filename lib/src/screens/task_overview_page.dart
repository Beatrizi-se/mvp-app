import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../models/task_model.dart';
import '../models/task_step_model.dart';
import '../widgets/app_header.dart';
import '../widgets/task_overview/task_overview_badge.dart';
import '../widgets/task_overview/task_overview_step_item.dart';
import '../widgets/task_overview/task_overview_action_button.dart';
import 'step_focus_page.dart';
import 'task_form_page.dart';

class TaskOverviewPage extends StatefulWidget {
  final TaskModel task;

  const TaskOverviewPage({super.key, required this.task});

  @override
  State<TaskOverviewPage> createState() => _TaskOverviewPageState();
}

class _TaskOverviewPageState extends State<TaskOverviewPage> {
  late TaskModel _currentTask;

  @override
  void initState() {
    super.initState();
    _currentTask = widget.task;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FF),
      appBar: AppHeader(
        onLeadingPressed: () => Navigator.pop(context),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(primaryColor),
            const SizedBox(height: 24),
            _buildProgressCard(primaryColor),
            const SizedBox(height: 16),
            _buildAISummary(primaryColor),
            const SizedBox(height: 32),
            Text(
              'Passos da tarefa',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF07143F),
              ),
            ),
            const SizedBox(height: 16),
            _buildStepsList(primaryColor),
            const SizedBox(height: 24),
            _buildActionButtons(primaryColor),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(Color primaryColor) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: primaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(Icons.book_outlined, color: primaryColor, size: 32),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _currentTask.title,
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    TaskOverviewBadge(icon: Icons.book, text: _currentTask.category, color: primaryColor),
                    const SizedBox(width: 8),
                    const TaskOverviewBadge(icon: Icons.flag_outlined, text: 'Média prioridade', color: Colors.orange),
                    if (_currentTask.date != null) ...[
                      const SizedBox(width: 8),
                      TaskOverviewBadge(
                        icon: Icons.calendar_today_outlined, 
                        text: '${DateFormat('dd/MM/yyyy').format(_currentTask.date!)} às ${_currentTask.time ?? "19:00"}', 
                        color: Colors.indigo,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
        Image.asset('assets/pato_piscando_image.png', height: 80),
      ],
    );
  }

  Widget _buildProgressCard(Color primaryColor) {
    final progress = _currentTask.progress;
    final percentage = (progress * 100).toInt();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 64,
                height: 64,
                child: CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 8,
                  backgroundColor: Colors.black.withValues(alpha: 0.05),
                  valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                ),
              ),
              Text(
                '$percentage%',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Progresso geral',
                  style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                Text(
                  _currentTask.progressText,
                  style: GoogleFonts.poppins(fontSize: 13, color: primaryColor, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 6,
                    backgroundColor: Colors.black.withValues(alpha: 0.05),
                    valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          _buildPuzzlePiece(primaryColor),
        ],
      ),
    );
  }

  Widget _buildPuzzlePiece(Color primaryColor) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: primaryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Icon(Icons.extension_outlined, color: primaryColor),
    );
  }

  Widget _buildAISummary(Color primaryColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: primaryColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.auto_awesome, color: primaryColor, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Resumo do Pato',
                      style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text('IA', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Você está indo bem! Que tal continuar com o próximo passo para manter o ritmo?',
                  style: GoogleFonts.poppins(fontSize: 13, color: Colors.black54, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _toggleStepCompletion(int index) {
    setState(() {
      final updatedSteps = List<TaskStep>.from(_currentTask.steps);
      final step = updatedSteps[index];
      updatedSteps[index] = step.copyWith(
        isCompleted: !step.isCompleted,
        completedAt: !step.isCompleted ? DateTime.now() : null,
      );
      _currentTask = _currentTask.copyWith(steps: updatedSteps);
    });
  }

  void _askDuckHelp() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.7,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.orange.withValues(alpha: 0.1),
                    child: const Icon(Icons.auto_awesome, color: Colors.orange),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Ajuda do Pato',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7F8FF),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: SingleChildScrollView(
                    child: Text(
                      'Olá! Eu sou o Pato. Vi que você está na tarefa "${_currentTask.title}".\n\nComo posso te ajudar hoje? Posso sugerir novos passos, explicar como fazer algum deles ou apenas te dar um incentivo! 🦆✨',
                      style: GoogleFonts.poppins(fontSize: 14, height: 1.6),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Digite sua dúvida...',
                  filled: true,
                  fillColor: Colors.black.withValues(alpha: 0.05),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.all(16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text('Enviar para o Pato'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepsList(Color primaryColor) {
    return ReorderableListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      onReorder: (oldIndex, newIndex) {
        setState(() {
          if (newIndex > oldIndex) newIndex -= 1;
          final updatedSteps = List<TaskStep>.from(_currentTask.steps);
          final step = updatedSteps.removeAt(oldIndex);
          updatedSteps.insert(newIndex, step);
          _currentTask = _currentTask.copyWith(steps: updatedSteps);
        });
      },
      children: List.generate(_currentTask.steps.length, (index) {
        final step = _currentTask.steps[index];
        final isNext = !step.isCompleted && (index == 0 || _currentTask.steps[index - 1].isCompleted);
        return Container(
          key: ValueKey('step_$index'),
          child: TaskOverviewStepItem(
            index: index,
            step: step,
            primaryColor: primaryColor,
            isNext: isNext,
            onStart: () => _startStep(index),
            onReview: () => _toggleStepCompletion(index),
          ),
        );
      }),
    );
  }

  void _startStep(int index) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StepFocusPage(task: _currentTask, stepIndex: index),
      ),
    );

    if (result == true) {
      setState(() {
        final updatedSteps = List<TaskStep>.from(_currentTask.steps);
        updatedSteps[index] = updatedSteps[index].copyWith(
          isCompleted: true,
          completedAt: DateTime.now(),
        );
        _currentTask = _currentTask.copyWith(steps: updatedSteps);
      });
    }
  }

  Widget _buildActionButtons(Color primaryColor) {
    return Row(
      children: [
        Expanded(
          child: TaskOverviewActionButton(
            icon: Icons.edit_outlined,
            title: 'Editar tarefa',
            subtitle: 'Modificar passos, data...',
            color: primaryColor.withValues(alpha: 0.05),
            iconColor: primaryColor,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TaskFormPage(task: _currentTask)),
              );
            },
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: TaskOverviewActionButton(
            icon: Icons.auto_awesome_outlined,
            title: 'Pedir ajuda ao Pato',
            subtitle: 'Dúvidas, sugestões...',
            color: const Color(0xFFFFF9E5),
            iconColor: Colors.orange,
            isIA: true,
            onTap: _askDuckHelp,
          ),
        ),
      ],
    );
  }
}
