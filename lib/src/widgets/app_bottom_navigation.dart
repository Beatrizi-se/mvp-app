import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const AppBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed, // Garante que todos os itens apareçam
      selectedItemColor: const Color(0xFF6C63FF),
      unselectedItemColor: Colors.black26,
      showUnselectedLabels: true,
      selectedLabelStyle: GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_filled),
          label: 'Início',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.videogame_asset_outlined),
          label: 'Jogos',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.list_alt_rounded),
          label: 'Tarefas',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.star_border_rounded),
          label: 'Favoritos',
        ),
      ],
    );
  }
}
