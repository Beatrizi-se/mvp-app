import 'dart:async';
import 'package:flutter/material.dart';
import '../models/memory_card_model.dart';
import '../widgets/memory_card.dart';
import '../widgets/memory_top_bar.dart';
import '../widgets/memory_header.dart';
import '../widgets/game_status_card.dart';

class MemoryGameStart extends StatefulWidget {
  final String dificuldade;

  const MemoryGameStart({
    super.key,
    required this.dificuldade,
  });

  @override
  State<MemoryGameStart> createState() => _MemoryGameStartState();
}

class _MemoryGameStartState extends State<MemoryGameStart> {
  List<MemoryCardModel> cards = [];

  int? primeiraCartaIndex;
  int? segundaCartaIndex;
  bool podeClicar = true;

  int paresEncontrados = 0;

  @override
  void initState() {
    super.initState();
    criarCartas();
  }

  List<IconData> iconesPorDificuldade() {
    final List<IconData> todosOsIcones = [
      Icons.star,
      Icons.favorite,
      Icons.nightlight_round,
      Icons.auto_awesome,
      Icons.pets,
      Icons.emoji_emotions,
      Icons.sunny,
      Icons.local_florist,
    ];

    if (widget.dificuldade == 'Fácil') {
      return todosOsIcones.take(4).toList();
    }

    if (widget.dificuldade == 'Médio') {
      return todosOsIcones.take(6).toList();
    }

    return todosOsIcones.take(8).toList();
  }

  void criarCartas() {
    final List<IconData> iconesBase = iconesPorDificuldade();

    cards = iconesBase.expand((icone) {
      return [
        MemoryCardModel(icon: icone),
        MemoryCardModel(icon: icone),
      ];
    }).toList();

    cards.shuffle();

    primeiraCartaIndex = null;
    segundaCartaIndex = null;
    podeClicar = true;
    paresEncontrados = 0;
  }

  void clicarNaCarta(int index) {
    if (!podeClicar) return;

    final carta = cards[index];

    if (carta.isFlipped || carta.isMatched) return;

    setState(() {
      carta.isFlipped = true;
    });

    if (primeiraCartaIndex == null) {
      primeiraCartaIndex = index;
    } else {
      segundaCartaIndex = index;
      compararCartas();
    }
  }

  void compararCartas() {
    podeClicar = false;

    final primeira = cards[primeiraCartaIndex!];
    final segunda = cards[segundaCartaIndex!];

    if (primeira.icon == segunda.icon) {
      setState(() {
        primeira.isMatched = true;
        segunda.isMatched = true;
        paresEncontrados++;
      });

      limparEscolha();

      if (paresEncontrados == cards.length ~/ 2) {
        Future.delayed(const Duration(milliseconds: 300), () {
          mostrarVitoria();
        });
      }
    } else {
      Timer(const Duration(milliseconds: 800), () {
        setState(() {
          primeira.isFlipped = false;
          segunda.isFlipped = false;
        });

        limparEscolha();
      });
    }
  }

  void limparEscolha() {
    primeiraCartaIndex = null;
    segundaCartaIndex = null;
    podeClicar = true;
  }

  void reiniciarJogo() {
    setState(() {
      criarCartas();
    });
  }

  void mostrarVitoria() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Parabéns! 🎉',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF07143F),
            ),
          ),
          content: const Text(
            'Você encontrou todos os pares!',
            style: TextStyle(
              fontSize: 15,
              color: Color(0xFF56617A),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                reiniciarJogo();
              },
              child: const Text(
                'Jogar novamente',
                style: TextStyle(
                  color: Color(0xFF6C4DE6),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F6FF),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const MemoryGameTopBar(),

              const SizedBox(height: 22),

              const MemoryGameHeader(),

              const SizedBox(height: 18),

              Row(
                children: [
                  const Expanded(
                    child: GameStatusCard(
                      icon: Icons.timer_outlined,
                      title: 'Tempo',
                      value: 'Livre',
                    ),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: GameStatusCard(
                      icon: Icons.star_rounded,
                      title: 'Pares',
                      value: '$paresEncontrados/${cards.length ~/ 2}',
                    ),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: GameStatusCard(
                      icon: Icons.bar_chart_rounded,
                      title: 'Nível',
                      value: widget.dificuldade,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              Expanded(
                child: GridView.builder(
                  itemCount: cards.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                  ),
                  itemBuilder: (context, index) {
                    final card = cards[index];

                    return MemoryCardWidget(
                      icon: card.icon,
                      isFlipped: card.isFlipped,
                      onTap: () {
                        clicarNaCarta(index);
                      },
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),

              Center(
                child: SizedBox(
                  width: 220,
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: reiniciarJogo,
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text(
                      'Reiniciar Jogo',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6C4DE6),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(26),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}