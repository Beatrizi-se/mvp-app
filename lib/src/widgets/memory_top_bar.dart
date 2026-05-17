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
           Image.asset(
            'assets/pato_logo.png',
            height: 60,)
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