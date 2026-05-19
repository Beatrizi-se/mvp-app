import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../models/task_model.dart';
import '../service/recent_tasks_service.dart';
import '../providers/auth_provider.dart';

import '../widgets/task_card.dart';
import '../widgets/duck_tip_card.dart';
import '../widgets/task_input_card.dart';
import '../widgets/app_bottom_navigation.dart';
import '../widgets/app_header.dart';

import '../widgets/side_drawer.dart';
import '../providers/settings_provider.dart';
import 'task_form_page.dart';
import 'initial_screen_game.dart';
import 'tasks_list_page.dart';
import 'favorites_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final int _selectedIndex = 0;

  final RecentTasksService _tasksService = RecentTasksService();

  List<TaskModel> _recentTasks = [];

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
        _recentTasks = tasks;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Não foi possível carregar as tarefas.';
      });
    }
  }

  void _handleNavigation(int index) {
    if (index == _selectedIndex) return;

    switch (index) {
      case 0:
        // Já está no Início
        break;

      case 1:
        Navigator.pushNamed(context, '/games');
        break;

      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const TasksListPage()),
        );
        break;

      case 3:
        Navigator.pushNamed(context, '/favorites');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final settingsProvider = Provider.of<SettingsProvider>(context);

    return Scaffold(
      drawer: const SideDrawer(),
      appBar: AppHeader(
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu, color: theme.colorScheme.onSurface, size: 32),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _fetchTasks,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  if (!settingsProvider.focusMode)
                    Positioned(
                      right: -38,
                      top: -25,
                      child: Image.asset(
                        'assets/pato_duvida_image.png',
                        width: 200,
                        fit: BoxFit.contain,
                      ),
                    ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: settingsProvider.focusMode ? 0 : 100),
                        child: Consumer<AuthProvider>(
                          builder: (context, authProvider, _) {
                            final userName = authProvider.user?.nome ?? 'usuário';
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Bem vindo, $userName! 👋',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    color: Colors.black54,
                                  ),
                                ),
                                RichText(
                                  text: TextSpan(
                                    style: GoogleFonts.poppins(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                    children: [
                                      const TextSpan(text: 'Vamos simplificar\no seu '),
                                      TextSpan(
                                        text: 'dia?',
                                        style: TextStyle(color: theme.colorScheme.primary),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 24),
                      TaskInputCard(
                        onAddTask: (text) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TaskFormPage(
                                task: text.isNotEmpty ? TaskModel(title: text, subtitle: '') : null,
                              ),
                            ),
                          ).then((_) => _fetchTasks());
                        },
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Tarefas Recentes',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const TasksListPage()),
                      );
                    },
                    child: Text(
                      'Ver todas >',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildRecentTasksSection(),
              const SizedBox(height: 32),
              if (!settingsProvider.focusMode)
                const DuckTipCard(
                  tip: 'Foque em um passo de cada vez. Você está indo bem!',
                  secondaryTip: 'Pequenos passos levam a grandes conquistas! ✨',
                ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: AppBottomNavigation(
        currentIndex: _selectedIndex,
        onTap: _handleNavigation,
      ),
    );
  }

  Widget _buildRecentTasksSection() {
    if (_isLoading) {
      return const SizedBox(
        height: 160,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (_errorMessage != null) {
      return SizedBox(
        height: 160,
        child: Center(
          child: Text(
            _errorMessage!,
            style: GoogleFonts.poppins(color: Colors.redAccent),
          ),
        ),
      );
    }

    if (_recentTasks.isEmpty) {
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
              style: GoogleFonts.poppins(color: Colors.black26),
            ),
          ],
        ),
      );
    }

    return SizedBox(
      height: 160,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _recentTasks.length > 3 ? 3 : _recentTasks.length,
        separatorBuilder: (context, index) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final task = _recentTasks[index];
          return TaskCard(
            title: task.title,
            subtitle: task.subtitle,
            progressText: task.progressText,
            progress: task.progress,
            isFavorite: task.isFavorite,
            onFavoriteTap: () async {
              try {
                await _tasksService.toggleFavorite(task);
                _fetchTasks();
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Erro ao favoritar: $e')),
                );
              }
            },
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TaskFormPage(task: task),
                ),
              ).then((_) => _fetchTasks());
            },
          );
        },
      ),
    );
  }
}
