import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/task_model.dart';
import 'task_card.dart';

class RecentTasksSection extends StatelessWidget {
  final Future<List<TaskModel>> tasksFuture;
  final VoidCallback? onRetry;

  const RecentTasksSection({
    super.key,
    required this.tasksFuture,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<TaskModel>>(
      future: tasksFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 160,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return SizedBox(
            height: 160,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Erro ao carregar tarefas',
                    style: GoogleFonts.poppins(color: Colors.redAccent),
                  ),
                  if (onRetry != null)
                    TextButton(
                      onPressed: onRetry,
                      child: const Text('Tentar novamente'),
                    ),
                ],
              ),
            ),
          );
        }

        final tasks = snapshot.data ?? [];

        if (tasks.isEmpty) {
          return Container(
            height: 160,
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.assignment_outlined, color: Colors.black12, size: 40),
                const SizedBox(height: 8),
                Text(
                  'Nenhuma tarefa recente',
                  style: GoogleFonts.poppins(color: Colors.black26),
                ),
              ],
            ),
          );
        }

        final displayCount = tasks.length > 3 ? 3 : tasks.length;

        return SizedBox(
          height: 160,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            itemCount: displayCount,
            separatorBuilder: (context, index) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              final task = tasks[index];
              return TaskCard(
                title: task.title,
                subtitle: task.subtitle,
                progressText: task.progressText,
                progress: task.progress,
              );
            },
          ),
        );
      },
    );
  }
}
