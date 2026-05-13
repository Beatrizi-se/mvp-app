import 'package:flutter/material.dart';

class MemoryCardWidget extends StatelessWidget {
  final IconData icon;
  final bool isFlipped;
  final VoidCallback onTap;

  const MemoryCardWidget({
    super.key,
    required this.icon,
    required this.isFlipped,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: isFlipped
              ? const Color(0xFFFFFFFF)
              : const Color(0xFFC4B5FD),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isFlipped
                ? const Color(0xFFE8E5F2)
                : const Color(0xFFC4B5FD),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Center(
          child: isFlipped
              ? Container(
            height: 54,
            width: 54,
            decoration: const BoxDecoration(
              color: Color(0xFFF0EBFF),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 30,
              color: const Color(0xFF6C4DE6),
            ),
          )
              : const Icon(Icons.egg,
            size: 42,
              color: Colors.white,
            ),
          )
          ),
    );
  }
}