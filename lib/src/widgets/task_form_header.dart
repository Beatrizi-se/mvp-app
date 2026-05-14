import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TaskFormHeader extends StatelessWidget {
  final bool isEditing;

  const TaskFormHeader({super.key, required this.isEditing});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isEditing ? 'Editar tarefa' : 'Nova tarefa',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            RichText(
              text: TextSpan(
                style: GoogleFonts.poppins(color: Colors.black54, fontSize: 16),
                children: const [
                  TextSpan(text: 'Vamos dividir em '),
                  TextSpan(
                    text: 'passos ',
                    style: TextStyle(color: Color(0xFF6C63FF), fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: 'menores?'),
                ],
              ),
            ),
          ],
        ),
        Positioned(
          right: -10,
          top: -30,
          child: Image.asset('assets/pato_muito_feliz_image.png', width: 100),
        ),
      ],
    );
  }
}
