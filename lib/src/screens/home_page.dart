import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/subtasks_button.dart';
import '../widgets/task_card.dart';
import '../widgets/duck_tip_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  // Lista simulando dados vindos do banco
  final List<Map<String, dynamic>> _recentTasks = [
    {
      'title': 'Lavar a louça',
      'subtitle': 'Próximo passo:\nEnxaguar os pratos',
      'progressText': '1/3',
      'progress': 0.33,
    },
    {
      'title': 'Organizar mesa de estudos',
      'subtitle': '4 passos',
      'progressText': '',
      'progress': 0.0,
    },
    {
      'title': 'Revisar matéria de história',
      'subtitle': '3 passos',
      'progressText': '',
      'progress': 0.0,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const Icon(Icons.menu, color: Colors.black87),
        title: RichText(
          text: TextSpan(
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            children: const [
              TextSpan(text: 'P'),
              TextSpan(text: 'A', style: TextStyle(color: Color(0xFFFFD862))),
              TextSpan(text: 'T'),
              TextSpan(text: 'O'),
            ],
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle_outlined, color: Colors.black87),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                // Coluna principal com Texto e Card
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Texto de boas-vindas
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

                    // Card de Entrada de Tarefa
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8E6FF).withOpacity(0.95),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF6C63FF).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(Icons.check_box_outlined,
                                    color: Color(0xFF6C63FF), size: 20),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'O que você precisa fazer agora?',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            decoration: InputDecoration(
                              hintText: 'Digite sua tarefa...',
                              hintStyle: GoogleFonts.poppins(color: Colors.black26),
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              suffixIcon: const Icon(Icons.add, color: Colors.black26),
                            ),
                          ),
                          const SizedBox(height: 16),
                          SubtasksButton(
                            text: 'Quebrar em passos',
                            icon: Icons.chevron_right,
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                // Pato posicionado sobre a Stack (fixo no topo/direita)
                Positioned(
                  right: -40,
                  top: 20,
                  child: Image.asset(
                    'assets/pato_card_image.png',
                    width: 210,
                    fit: BoxFit.contain,
                  ),
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
            SizedBox(
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
                      title: task['title'],
                      subtitle: task['subtitle'],
                      progressText: task['progressText'],
                      progress: task['progress'],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 32),
            const DuckTipCard(
              tip: 'Foque em um passo de cada vez. Você está indo bem!',
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
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
          BottomNavigationBarItem(
            icon: Icon(Icons.star_border_rounded),
            label: 'Favoritos',
          ),
        ],
      ),
    );
  }
}
