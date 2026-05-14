import 'package:flutter/material.dart';

class DifficultyCard extends StatelessWidget {
  final String titulo;
  final String descricao;
  final bool selecionado;
  final VoidCallback onTap;

  const DifficultyCard({
    super.key,
    required this.titulo,
    required this.descricao,
    required this.selecionado,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 112,
        padding: const EdgeInsets.symmetric(
          horizontal: 6,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selecionado
                ? const Color(0xFF6C4DE6)
                : const Color(0xFFE8E5F2),
            width: selecionado ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircleAvatar(
                    radius: 18,
                    backgroundColor: Color(0xFFF0EBFF),
                    child: Icon(
                      Icons.bar_chart_rounded,
                      color: Color(0xFF6C4DE6),
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
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF07143F),
                    ),
                  ),

                  const SizedBox(height: 3),

                  Text(
                    descricao,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 9.5,
                      color: Color(0xFF56617A),
                      height: 1.15,
                    ),
                  ),
                ],
              ),
            ),

            if (selecionado)
              const Positioned(
                top: 0,
                right: 0,
                child: CircleAvatar(
                  radius: 10,
                  backgroundColor: Color(0xFF6C4DE6),
                  child: Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 14,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}