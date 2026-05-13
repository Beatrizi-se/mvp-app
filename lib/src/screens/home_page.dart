import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/task_model.dart';
import '../service/recent_tasks_service.dart';
import '../widgets/app_bottom_navigation.dart';
import '../widgets/duck_tip_card.dart';
import '../widgets/section_header.dart';
import '../widgets/task_card.dart';
import '../widgets/task_input_card.dart';
import '../widgets/tasks_tab.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
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

  void _onNavTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _openTaskForm() {
    Navigator.pushNamed(context, '/task-form');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const Icon(Icons.menu, color: Colors.black87, size: 40),
        title: Image.asset('assets/pato_logo.png', height: 60),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.account_circle_outlined,
              color: Colors.black87,
              size: 40,
            ),
            onPressed: () {},
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: _buildPageBody(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF6C63FF),
        onPressed: _openTaskForm,
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: AppBottomNavigation(
        currentIndex: _selectedIndex,
        onTap: _onNavTap,
      ),
    );
  }

  Widget _buildPageBody() {
    switch (_selectedIndex) {
      case 1:
        return TasksTab(
          tasks: _recentTasks,
          isLoading: _isLoading,
          errorMessage: _errorMessage,
          onRefresh: _fetchTasks,
          onAddTask: _openTaskForm,
        );
      case 2:
        return _buildFavoritesPage();
      default:
        return _buildHomePage();
    }
  }

  Widget _buildHomePage() {
    return RefreshIndicator(
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
                      padding: const EdgeInsets.only(right: 100),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Bem vindo, usuário! 👋',
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
                              children: const [
                                TextSpan(text: 'Vamos simplificar\no seu '),
                                TextSpan(
                                  text: 'dia?',
                                  style: TextStyle(color: Color(0xFF6C63FF)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    TaskInputCard(onAddTask: _openTaskForm),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 32),
            SectionHeader(
              title: 'Tarefas Recentes',
              actionLabel: 'Ver todas >',
              onActionTap: () => _onNavTap(1),
            ),
            const SizedBox(height: 12),
            _buildRecentTasksSection(),
            const SizedBox(height: 32),
            const DuckTipCard(
              tip: 'Foque em um passo de cada vez. Você está indo bem!',
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildFavoritesPage() {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          const SizedBox(height: 40),
          Text(
            'Favoritos',
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Aqui aparecerão suas tarefas favoritas assim que você marcar algumas.',
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.black54),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Icon(Icons.star_outline, size: 100, color: Colors.black12),
        ],
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
        child: Text(
          'Nenhuma tarefa recente',
          style: GoogleFonts.poppins(color: Colors.black26),
        ),
      );
    }

    final taskCount = _recentTasks.length < 3 ? _recentTasks.length : 3;

    return SizedBox(
      height: 160,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: taskCount,
        itemBuilder: (context, index) {
          final task = _recentTasks[index];
          return Padding(
            padding: EdgeInsets.only(right: index == taskCount - 1 ? 0 : 16.0),
            child: TaskCard(
              title: task.title,
              subtitle: task.subtitle,
              progressText: task.progressText,
              progress: task.progress,
              onTap: _openTaskForm,
            ),
          );
        },
      ),
    );
  }
}
