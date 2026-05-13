import 'package:flutter/material.dart';

class MemoryGameTopBar extends StatelessWidget {
  const MemoryGameTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Color(0xFF56617A),
            size: 26,
          ),
        ),

        const Spacer(),

        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'P',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Color(0xFF07143F),
              ),
            ),

            const SizedBox(width: 5),

            Image.asset(
              'assets/pato_animado_image.png',
              height: 34,
              width: 34,
              fit: BoxFit.contain,
            ),

            const SizedBox(width: 5),

            const Text(
              'TO',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Color(0xFF07143F),
              ),
            ),
          ],
        ),

        const Spacer(),

        const Icon(
          Icons.account_circle_outlined,
          color: Color(0xFF56617A),
          size: 32,
        ),
      ],
    );
  }
}