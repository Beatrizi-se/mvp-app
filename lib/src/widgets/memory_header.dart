import 'package:flutter/material.dart';

class MemoryGameHeader extends StatelessWidget {
  const MemoryGameHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Jogo da Memória',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF07143F),
                ),
              ),

              SizedBox(height: 6),

              Text(
                'Encontre os pares e treine sua memória!',
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF56617A),
                ),
              ),
            ],
          ),
        ),

        Image.asset(
          'assets/pato_piscando_image.png',
          height: 82,
          width: 82,
          fit: BoxFit.contain,
        ),
      ],
    );
  }
}