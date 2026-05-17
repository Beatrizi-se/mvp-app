import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/task_model.dart';
import '../service/recent_tasks_service.dart';

import '../widgets/task_list_card.dart';
import '../widgets/duck_tip_card.dart';
import '../widgets/app_bottom_navigation.dart';
import '../widgets/app_header.dart';

import 'task_form_page.dart';
import 'initial_screen_game.dart';

class TasksListPage extends StatefulWidget {
  const TasksListPage({super.key});

  @override
  State<TasksListPage> createState() => _TasksListPageState();
}

class _TasksListPageState extends State<TasksListPage> {
  final int _selectedIndex = 2;
  int _selectedFilterIndex = 0;
  final List<String> _filters = ['Todas', 'Pendentes', 'Concluídas'];
  final RecentTasksService _tasksService = RecentTasksService();

  List<TaskModel> _tasks = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchTasks();
  }

  Future<void> _fetchTasks() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final tasks = await _tasksService.getAllTasks();

      setState(() {
        _tasks = tasks;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Erro ao carregar tarefas';
      });
    }
  }

  void _handleNavigation(int index) {
    if (index == _selectedIndex) return;

    switch (index) {
      case 0:
        Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
        break;

      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const InitialScreenGame()),
        );
        break;

      case 2:
        break;

      case 3:
        // Tela favoritos
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FF),
      appBar: AppHeader(
        onLeadingPressed: () => Navigator.pop(context),
      ),
      body: RefreshIndicator(
        onRefresh: _fetchTasks,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 24),
              _buildFilters(),
              const SizedBox(height: 24),
              _buildSearchBar(),
              const SizedBox(height: 24),
              _buildTasksListSection(),
              const SizedBox(height: 24),
              const DuckTipCard(
                tip: 'Que tal começar pela menor tarefa?',
                secondaryTip: 'Pequenos passos, grandes conquistas! ✨',
              ),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TaskFormPage()),
          ).then((_) => _fetchTasks());
        },
        backgroundColor: const Color(0xFF6C63FF),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),
      bottomNavigationBar: AppBottomNavigation(
        currentIndex: _selectedIndex,
        onTap: _handleNavigation,
      ),
    );
  }

  Widget _buildHeader() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          right: -10,
          top: -10,
          child: Image.asset('assets/pato_muito_feliz_image.png', height: 40),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Minhas tarefas',
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(width: 8),
                const Text('📋', style: TextStyle(fontSize: 20)),
              ],
            ),
            Text(
              'Vamos por partes, um passo de cada vez.',
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.black54),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFilters() {
    return Row(
      children: List.generate(_filters.length, (index) {
        final isSelected = _selectedFilterIndex == index;
        return Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: GestureDetector(
            onTap: () {
              setState(() {
                _selectedFilterIndex = index;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF6C63FF) : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF6C63FF)
                      : const Color(0xFFE0E0E0),
                ),
              ),
              child: Row(
                children: [
                  if (index == 0)
                    Icon(
                      Icons.grid_view_rounded,
                      size: 16,
                      color: isSelected ? Colors.white : Colors.black54,
                    ),
                  if (index == 1)
                    Icon(
                      Icons.access_time_rounded,
                      size: 16,
                      color: isSelected ? Colors.white : Colors.black54,
                    ),
                  if (index == 2)
                    Icon(
                      Icons.check_circle_outline_rounded,
                      size: 16,
                      color: isSelected ? Colors.white : Colors.black54,
                    ),
                  const SizedBox(width: 4),
                  Text(
                    _filters[index],
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: isSelected ? Colors.white : Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          const Icon(Icons.search, color: Colors.black26),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Buscar tarefa...',
                hintStyle: GoogleFonts.poppins(
                  color: Colors.black26,
                  fontSize: 14,
                ),
                border: InputBorder.none,
              ),
            ),
          ),
          const Icon(Icons.tune_rounded, color: Color(0xFF6C63FF)),
        ],
      ),
    );
  }

  Widget _buildTasksListSection() {
    if (_isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Text(
            _errorMessage!,
            style: GoogleFonts.poppins(color: Colors.redAccent),
          ),
        ),
      );
    }

    if (_tasks.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Text(
            'Nenhuma tarefa encontrada',
            style: GoogleFonts.poppins(color: Colors.black38),
          ),
        ),
      );
    }

    return Column(
      children: _tasks.map((task) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: TaskListCard(
            title: task.title,
            nextStep: task.subtitle,
            category: task.category,
            progressText: task.progressText,
            progress: task.progress,
            icon: Icons.task_alt_rounded,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => TaskFormPage(task: task)),
              ).then((_) => _fetchTasks());
            },
          ),
        );
      }).toList(),
    );
  }
}
