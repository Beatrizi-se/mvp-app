import 'package:flutter/material.dart';
import '../widgets/difficulty_card.dart';
import '../widgets/memory_info_card.dart';
import '../widgets/duck_tip_card.dart';
import '../widgets/memory_button.dart';

class InitialScreenGame extends StatefulWidget {
  const InitialScreenGame({super.key});

  @override
  State<InitialScreenGame> createState() => _InitialScreenGameState();
}

class _InitialScreenGameState extends State<InitialScreenGame> {
  String dificuldadeSelecionada = 'Fácil';

  int get quantidadeCartas {
    if (dificuldadeSelecionada == 'Médio') return 12;
    if (dificuldadeSelecionada == 'Difícil') return 16;
    return 8;
  }

  int get quantidadePares => quantidadeCartas ~/ 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFF),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 40),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // TOPO
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.arrow_back, size: 28, color: Color(0xFF07143F)),
                        ),
                        const Spacer(),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('P', style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold, letterSpacing: 4, color: Color(0xFF07143F))),
                            const SizedBox(width: 8),
                            Image.asset('assets/pato_animado_image.png', height: 36, width: 36),
                            const SizedBox(width: 8),
                            const Text('TO', style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold, letterSpacing: 4, color: Color(0xFF07143F))),
                          ],
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.account_circle_outlined, size: 32, color: Color(0xFF56617A)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // TÍTULO + IMAGEM
                    Row(
                      children: [
                        const Expanded(
                          child: Text('Jogo da\nMemória', style: TextStyle(fontSize: 38, fontWeight: FontWeight.bold, color: Color(0xFF07143F), height: 1.1)),
                        ),
                        Image.asset('assets/pato_cartas_image.png', height: 170, width: 170),
                      ],
                    ),
                    const SizedBox(height: 15),
                    const Text('Treine seu foco e encontre os pares no seu ritmo.', style: TextStyle(fontSize: 17, color: Color(0xFF56617A), height: 1.4)),
                    const SizedBox(height: 30),

                    // DIFICULDADE
                    const Text('Escolha a dificuldade', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF07143F))),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(child: DifficultyCard(titulo: 'Fácil', descricao: 'Ideal para\ncomeçar', selecionado: dificuldadeSelecionada == 'Fácil', onTap: () => setState(() => dificuldadeSelecionada = 'Fácil'))),
                        const SizedBox(width: 5),
                        Expanded(child: DifficultyCard(titulo: 'Médio', descricao: 'Um pouco\nmais desafio', selecionado: dificuldadeSelecionada == 'Médio', onTap: () => setState(() => dificuldadeSelecionada = 'Médio'))),
                        const SizedBox(width: 5),
                        Expanded(child: DifficultyCard(titulo: 'Difícil', descricao: 'Para mentes\ncuriosas', selecionado: dificuldadeSelecionada == 'Difícil', onTap: () => setState(() => dificuldadeSelecionada = 'Difícil'))),
                      ],
                    ),
                    const SizedBox(height: 15),

                    // INFO CARDS
                    Row(
                      children: [
                        Expanded(child: MemoryInfoCard(icon: Icons.star_rounded, titulo: 'Pares', valor: '$quantidadeCartas', descricao: '$quantidadePares pares')),
                        const SizedBox(width: 5),
                        const Expanded(child: MemoryInfoCard(icon: Icons.access_time_rounded, titulo: 'Tempo', valor: 'Livre', descricao: 'Sem limite')),
                        const SizedBox(width: 5),
                        const Expanded(child: MemoryInfoCard(icon: Icons.psychology_rounded, titulo: 'Treino', valor: 'Memória', descricao: 'Exercite sua mente')),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // CARD DE DICA UNIFICADO
                    DuckTipCard(
                      title: 'Dica do Pato 💜',
                      tip: 'Respire fundo, foque e divirta-se!',
                      secondaryTip: 'Cada par encontrado fortalece seu cérebro! ✨',
                      backgroundColor: const Color(0xFFFFF7E8),
                      leading: Image.asset('assets/pato_muito_feliz_image.png', height: 45, width: 45),
                      trailing: const CircleAvatar(
                        radius: 19,
                        backgroundColor: Color(0xFFF0EBFF),
                        child: Icon(Icons.lightbulb_outline_rounded, color: Color(0xFF6C4DE6), size: 23),
                      ),
                    ),

                    const SizedBox(height: 24),
                    MemoryButton(dificuldade: dificuldadeSelecionada),
                    const SizedBox(height: 28),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
