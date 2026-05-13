import 'package:flutter/material.dart';

class MemoryTipCard extends StatelessWidget {
  const MemoryTipCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7E8),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Image.asset(
            'assets/pato_muito_feliz_image.png',
            height: 45,
            width: 45,
            fit: BoxFit.contain,
          ),

          const SizedBox(width: 10),

          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Dica do Pato 💜',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF07143F),
                  ),
                ),

                SizedBox(height: 5),

                Text(
                  'Respire fundo, foque e divirta-se!',
                  style: TextStyle(
                    fontSize: 11.5,
                    color: Color(0xFF56617A),
                    height: 1.25,
                  ),
                ),

                SizedBox(height: 3),

                Text(
                  'Cada par encontrado fortalece seu cérebro! ✨',
                  style: TextStyle(
                    fontSize: 11.5,
                    color: Color(0xFF56617A),
                    height: 1.25,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          const CircleAvatar(
            radius: 19,
            backgroundColor: Color(0xFFF0EBFF),
            child: Icon(
              Icons.lightbulb_outline_rounded,
              color: Color(0xFF6C4DE6),
              size: 23,
            ),
          ),
        ],
      ),
    );
  }
}