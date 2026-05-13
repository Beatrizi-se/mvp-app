import 'package:flutter/material.dart';

class MemoryInfoCard extends StatelessWidget {
  final IconData icon;
  final String titulo;
  final String valor;
  final String descricao;

  const MemoryInfoCard({
    super.key,
    required this.icon,
    required this.titulo,
    required this.valor,
    required this.descricao,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      padding: const EdgeInsets.symmetric(
        horizontal: 6,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFE8E5F2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: const Color(0xFFF0EBFF),
              child: Icon(
                icon,
                color: const Color(0xFF6C4DE6),
                size: 21,
              ),
            ),

            const SizedBox(height: 7),

            Text(
              titulo,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 10,
                color: Color(0xFF56617A),
              ),
            ),

            const SizedBox(height: 2),

            Text(
              valor,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF07143F),
              ),
            ),

            const SizedBox(height: 3),

            Text(
              descricao,
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 8.8,
                color: Color(0xFF56617A),
                height: 1.15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}