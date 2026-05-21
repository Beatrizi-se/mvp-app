import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/task_model.dart';
import '../models/task_step_model.dart';
import '../providers/task_provider.dart';
import '../service/recent_tasks_service.dart';
import '../widgets/app_header.dart';
import '../widgets/task_overview/task_overview_badge.dart';
import '../widgets/task_overview/task_overview_step_item.dart';
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
  final RecentTasksService _recentTasksService = RecentTasksService();

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
        onLeadingPressed: () => Navigator.pop(context, true),
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
            _buildEditAction(primaryColor),
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

  Widget _buildEditAction(Color primaryColor) {
    return GestureDetector(
      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TaskFormPage(task: _currentTask)),
        );
        if (result == true) {
          _refreshTask();
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: primaryColor.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: primaryColor.withValues(alpha: 0.1)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: primaryColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.edit_outlined, color: primaryColor, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Editar tarefa',
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    'Modificar passos, data ou prioridade',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: primaryColor.withValues(alpha: 0.5)),
          ],
        ),
      ),
    );
  }

  void _toggleStepCompletion(int index) async {
    final updatedSteps = List<TaskStep>.from(_currentTask.steps);
    final step = updatedSteps[index];
    updatedSteps[index] = step.copyWith(
      isCompleted: !step.isCompleted,
      completedAt: !step.isCompleted ? DateTime.now() : null,
    );
    
    final updatedTask = _currentTask.copyWith(steps: updatedSteps);

    // Atualiza via Provider (isso avisa todas as telas)
    try {
      await context.read<TaskProvider>().updateTaskProgress(updatedTask);
      setState(() {
        _currentTask = updatedTask;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Não foi possível salvar o progresso: $e')),
        );
      }
    }
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

  Future<void> _refreshTask() async {
    try {
      final tasks = await _recentTasksService.getAllTasks();
      final updatedTask = tasks.firstWhere((t) => t.id == _currentTask.id);
      setState(() {
        _currentTask = updatedTask;
      });
    } catch (e) {
      debugPrint('Erro ao atualizar tarefa: $e');
    }
  }

  void _startStep(int index) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StepFocusPage(task: _currentTask, stepIndex: index),
      ),
    );

    if (result == true) {
      final updatedSteps = List<TaskStep>.from(_currentTask.steps);
      updatedSteps[index] = updatedSteps[index].copyWith(
        isCompleted: true,
        completedAt: DateTime.now(),
      );
      final updatedTask = _currentTask.copyWith(steps: updatedSteps);

      try {
        
        if (!mounted) return;

        await context.read<TaskProvider>().updateTaskProgress(updatedTask);
        setState(() {
          _currentTask = updatedTask;
        });
      } catch (e) {
        debugPrint('Erro ao salvar conclusão do passo: $e');
      }
    }
  }

}
