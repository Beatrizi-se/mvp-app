import 'package:flutter/material.dart';
import 'package:mobile/src/screens/memory_game_start.dart';

  class MemoryButton extends StatelessWidget {
  final String dificuldade;

  const MemoryButton({
  super.key,
  required this.dificuldade,
  });

  void _mostrarInstrucoes(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Como jogar?',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF07143F),
            ),
          ),
          content: const Text(
            'Encontre os pares iguais.\n\n'
                'Toque nas cartas para virar.\n\n'
                'Quando encontrar todos os pares, você vence!',
            style: TextStyle(
              fontSize: 15,
              color: Color(0xFF56617A),
              height: 1.4,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Entendi',
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

  void _comecarJogo(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MemoryGameStart(
          dificuldade: dificuldade,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton.icon(
            onPressed: () {
              _comecarJogo(context);
            },
            icon: const Icon(
              Icons.play_circle_fill_rounded,
              size: 28,
            ),
            label: const Text(
              'Começar jogo',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6C4DE6),
              foregroundColor: Colors.white,
              elevation: 8,
              shadowColor: const Color(0xFF6C4DE6).withOpacity(0.35),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
            ),
          ),
        ),

        const SizedBox(height: 14),

        SizedBox(
          width: double.infinity,
          height: 54,
          child: OutlinedButton.icon(
            onPressed: () {
              _mostrarInstrucoes(context);
            },
            icon: const Icon(
              Icons.menu_book_rounded,
              size: 26,
            ),
            label: const Text(
              'Ver instruções',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF6C4DE6),
              side: const BorderSide(
                color: Color(0xFFB7A8FF),
                width: 1.5,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
            ),
          ),
        ),
      ],
    );
  }
}