import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/task_model.dart';
import '../service/recent_tasks_service.dart';
import '../widgets/task_list_card.dart';
import '../widgets/app_header.dart';
import '../widgets/app_bottom_navigation.dart';
import 'task_form_page.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  final RecentTasksService _tasksService = RecentTasksService();
  List<TaskModel> _favoriteTasks = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchFavorites();
  }

  Future<void> _fetchFavorites() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final allTasks = await _tasksService.getAllTasks();
      setState(() {
        _favoriteTasks = allTasks.where((task) => task.isFavorite).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Erro ao carregar favoritos';
      });
    }
  }

  Future<void> _toggleFavorite(TaskModel task) async {
    try {
      await _tasksService.toggleFavorite(task);
      _fetchFavorites();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao desfavoritar: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppHeader(
        onLeadingPressed: () => Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false),
      ),
      body: RefreshIndicator(
        onRefresh: _fetchFavorites,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 32),
              _buildFavoritesList(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: AppBottomNavigation(
        currentIndex: 3,
        onTap: (index) {
          if (index == 3) return;
          if (index == 0) Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
          if (index == 1) Navigator.pushReplacementNamed(context, '/games'); // Se você tiver uma rota de jogos
          if (index == 2) Navigator.pushReplacementNamed(context, '/tasks-list');
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Favoritos',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(width: 8),
            const Text('⭐', style: TextStyle(fontSize: 24)),
          ],
        ),
        Text(
          'Suas tarefas mais importantes \nem um só lugar.',
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }

  Widget _buildFavoritesList() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Text(
          _errorMessage!,
          style: GoogleFonts.poppins(color: Colors.redAccent),
        ),
      );
    }

    if (_favoriteTasks.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 60),
          child: Column(
            children: [
              const Icon(Icons.star_outline_rounded, size: 64, color: Colors.black12),
              const SizedBox(height: 16),
              Text(
                'Nenhuma tarefa favoritada',
                style: GoogleFonts.poppins(color: Colors.black38, fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(
                'Favorite tarefas para que elas \napareçam aqui!',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(color: Colors.black26, fontSize: 13),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: _favoriteTasks.map((task) {
        return TaskListCard(
          title: task.title,
          nextStep: task.subtitle,
          category: task.category,
          progressText: task.progressText,
          progress: task.progress,
          icon: Icons.task_alt_rounded,
          isFavorite: true,
          onFavoriteTap: () => _toggleFavorite(task),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => TaskFormPage(task: task)),
            ).then((_) => _fetchFavorites());
          },
        );
      }).toList(),
    );
  }
}
