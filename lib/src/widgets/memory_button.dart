import 'package:flutter/material.dart';
import '../screens/memory_game_start.dart';
import 'app_button.dart';

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
            AppButton(
              text: 'Entendi',
              width: 120,
              height: 40,
              type: AppButtonType.ghost,
              onPressed: () => Navigator.pop(context),
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
        AppButton(
          text: 'Começar jogo',
          icon: Icons.play_circle_fill_rounded,
          color: const Color(0xFF6C4DE6),
          borderRadius: 28,
          onPressed: () => _comecarJogo(context),
        ),
        const SizedBox(height: 14),
        AppButton(
          text: 'Ver instruções',
          icon: Icons.menu_book_rounded,
          type: AppButtonType.outlined,
          color: const Color(0xFFB7A8FF),
          textColor: const Color(0xFF6C4DE6),
          borderRadius: 28,
          height: 54,
          onPressed: () => _mostrarInstrucoes(context),
        ),
      ],
    );
  }
}
