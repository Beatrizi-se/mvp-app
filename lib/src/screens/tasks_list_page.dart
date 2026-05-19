import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/task_model.dart';
import '../service/recent_tasks_service.dart';

import '../widgets/task_list_card.dart';
import '../widgets/duck_tip_card.dart';
import '../widgets/app_bottom_navigation.dart';
import '../widgets/app_header.dart';

import 'task_form_page.dart';
import 'task_overview_page.dart';



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
  List<TaskModel> _filteredTasks = [];
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
        _applyFilter();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Erro ao carregar tarefas';
      });
    }
  }

  void _applyFilter() {
    setState(() {
      if (_selectedFilterIndex == 0) {
        _filteredTasks = List.from(_tasks);
      } else if (_selectedFilterIndex == 1) {
        // Pendentes: progresso < 1.0 (ou se não tiver passos)
        _filteredTasks = _tasks.where((task) => task.progress < 1.0).toList();
      } else if (_selectedFilterIndex == 2) {
        // Concluídas: progresso == 1.0
        _filteredTasks = _tasks.where((task) => task.progress == 1.0).toList();
      }
    });
  }

  void _handleNavigation(int index) {
    if (index == _selectedIndex) return;

    switch (index) {
      case 0:
        Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
        break;

      case 1:
        Navigator.pushReplacementNamed(context, '/games');
        break;

      case 2:
        break;

      case 3:
        Navigator.pushReplacementNamed(context, '/favorites');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
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
              _buildFilters(context),
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
          backgroundColor: theme.colorScheme.primary,
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
          right: -12,
          top: -10,
          child: Image.asset('assets/pato_muito_feliz_image.png', height: 126),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Flexible(
                  child: Text(
                    'Minhas tarefas',
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                const Text('📋', style: TextStyle(fontSize: 20)),
              ],
            ),
            Text(
              'Vamos por partes, \num passo de cada vez.',
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.black54),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFilters(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(_filters.length, (index) {
          final isSelected = _selectedFilterIndex == index;
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedFilterIndex = index;
                });
                _applyFilter();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? theme.colorScheme.primary : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? theme.colorScheme.primary
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
      ),
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
          const Icon(Icons.tune_rounded, color: Colors.black45),
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

    if (_filteredTasks.isEmpty) {
      String message = 'Nenhuma tarefa encontrada';
      if (_selectedFilterIndex == 1) message = 'Você não tem tarefas pendentes';
      if (_selectedFilterIndex == 2) message = 'Você não tem tarefas concluídas';
      
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Text(
            message,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(color: Colors.black38),
          ),
        ),
      );
    }

    return Column(
      children: _filteredTasks.map((task) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: TaskListCard(
            title: task.title,
            nextStep: task.subtitle,
            category: task.category,
            progressText: task.progressText,
            progress: task.progress,
            icon: Icons.task_alt_rounded,
            isFavorite: task.isFavorite,
            onFavoriteTap: () async {
              try {
                await _tasksService.toggleFavorite(task);
                if (!mounted) return;
                _fetchTasks();
              } catch (e) {
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Erro ao favoritar: $e')),
                );
              }
            },
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => TaskOverviewPage(task: task)),
              ).then((_) => _fetchTasks());
            },
          ),
        );
      }).toList(),
    );
  }
}
