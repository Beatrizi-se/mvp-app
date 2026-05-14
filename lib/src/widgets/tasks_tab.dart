import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/task_model.dart';
import 'task_card.dart';
import 'app_button.dart';
import 'section_header.dart';

class TasksTab extends StatelessWidget {
  final List<TaskModel> tasks;
  final bool isLoading;
  final String? errorMessage;
  final VoidCallback onAddTask;
  final VoidCallback onRefresh;

  const TasksTab({
    super.key,
    required this.tasks,
    required this.isLoading,
    required this.onAddTask,
    required this.onRefresh,
    this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async => onRefresh(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            SectionHeader(
              title: 'Todas as tarefas',
              actionLabel: 'Adicionar',
              onActionTap: onAddTask,
            ),
            const SizedBox(height: 16),
            if (isLoading)
              const SizedBox(
                height: 220,
                child: Center(child: CircularProgressIndicator()),
              )
            else if (errorMessage != null)
              SizedBox(
                height: 220,
                child: Center(
                  child: Text(
                    errorMessage!,
                    style: GoogleFonts.poppins(color: Colors.redAccent),
                  ),
                ),
              )
            else if (tasks.isEmpty)
              Container(
                height: 220,
                alignment: Alignment.center,
                child: Text(
                  'Nenhuma tarefa cadastrada ainda.',
                  style: GoogleFonts.poppins(color: Colors.black26),
                ),
              )
            else
              Column(
                children: tasks
                    .map(
                      (task) => Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: TaskCard(
                          title: task.title,
                          subtitle: task.subtitle,
                          progressText: task.progressText,
                          progress: task.progress,
                        ),
                      ),
                    )
                    .toList(),
              ),
            const SizedBox(height: 24),
            AppButton(
              text: 'Adicionar nova tarefa',
              onPressed: onAddTask,
            ),
          ],
        ),
      ),
    );
  }
}
