import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/task_model.dart';
import 'task_card.dart';

class RecentTasksSection extends StatelessWidget {

  final List<TaskModel> tasks;

  const RecentTasksSection({
    super.key,
    required this.tasks,
  });

  @override
  Widget build(BuildContext context) {

    if (tasks.isEmpty) {

      return Container(
        height: 160,
        alignment: Alignment.center,

        child: Column(
          mainAxisSize: MainAxisSize.min,

          children: [

            const Icon(
              Icons.assignment_outlined,
              color: Colors.black12,
              size: 40,
            ),

            const SizedBox(height: 8),

            Text(
              'Nenhuma tarefa recente',

              style: GoogleFonts.poppins(
                color: Colors.black26,
              ),
            ),
          ],
        ),
      );
    }

    final displayCount =
    tasks.length > 3 ? 3 : tasks.length;

    return SizedBox(
      height: 160,

      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,

        itemCount: displayCount,

        separatorBuilder: (context, index) =>
        const SizedBox(width: 16),

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
  }
}