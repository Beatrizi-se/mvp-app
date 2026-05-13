import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/task_model.dart';
import '../service/recent_tasks_service.dart';
import '../widgets/task_card.dart';
import '../widgets/duck_tip_card.dart';
import '../widgets/task_input_card.dart';
import 'initial_screen_game.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const Icon(Icons.menu, color: Colors.black87, size: 40,),
        title: Image.asset('assets/pato_logo.png',
          height: 60),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle_outlined, color: Colors.black87, size: 40,),
            onPressed: () {},
          ),
          const SizedBox(width:16),
        ],
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
                      const TaskInputCard(),
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
                    onPressed: () {},
                    child: Text(
                      'Ver todas >',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: const Color(0xFF6C63FF),
                      ),
                    ),
                  ),
                ],
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
      ),
        bottomNavigationBar: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: (index) {
              setState(() => _selectedIndex = index);

              if (index == 2) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const InitialScreenGame(),
                  ),
                );
              }
            },
        selectedItemColor: const Color(0xFF6C63FF),
        unselectedItemColor: Colors.black26,
        showUnselectedLabels: true,
        selectedLabelStyle: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w500),
        unselectedLabelStyle: GoogleFonts.poppins(fontSize: 12),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: 'Início',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt_rounded),
            label: 'Tarefas',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.videogame_asset_sharp),
          label: 'Jogos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star_border_rounded),
            label: 'Favoritos',
          ),
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

    return SizedBox(
      height: 160,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 3,
        itemBuilder: (context, index) {
          final task = _recentTasks[index];
          return Padding(
            padding: EdgeInsets.only(
              right: index == _recentTasks.length - 1 ? 0 : 16.0,
            ),
            child: TaskCard(
              title: task.title,
              subtitle: task.subtitle,
              progressText: task.progressText,
              progress: task.progress,
            ),
          );
        },
      ),
    );
  }
}
