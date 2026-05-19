import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';

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
    final theme = Theme.of(context);
    final settingsProvider = Provider.of<SettingsProvider>(context);
    final isFocusMode = settingsProvider.focusMode;

    // Define os itens baseados no Modo Foco
    final items = [
      const BottomNavigationBarItem(
        icon: Icon(Icons.home_filled),
        label: 'Início',
      ),
      if (!isFocusMode)
        const BottomNavigationBarItem(
          icon: Icon(Icons.videogame_asset_outlined),
          label: 'Jogos',
        ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.list_alt_rounded),
        label: 'Tarefas',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.star_border_rounded),
        label: 'Favoritos',
      ),
    ];

    // Ajusta o índice se necessário quando um item é removido
    // No modo foco, se o índice original era 1 (Jogos), ele vira 0 (ou o que for apropriado)
    // Mas geralmente o gerenciamento de índice é feito no pai.
    
    return BottomNavigationBar(
      currentIndex: _getAdjustedIndex(isFocusMode),
      onTap: (index) => _handleTap(index, isFocusMode),
      type: BottomNavigationBarType.fixed,
      selectedItemColor: theme.colorScheme.primary,
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
      items: items,
    );
  }

  int _getAdjustedIndex(bool isFocusMode) {
    if (!isFocusMode) return currentIndex;
    // Se estiver no modo foco e o índice for > 1 (Jogos), subtraímos 1
    if (currentIndex > 1) return currentIndex - 1;
    // Se por algum motivo o índice for 1 (Jogos) e estivermos no modo foco, voltamos para o Início (0)
    if (currentIndex == 1) return 0;
    return currentIndex;
  }

  void _handleTap(int index, bool isFocusMode) {
    if (!isFocusMode) {
      onTap(index);
      return;
    }
    // Se estiver no modo foco, mapeamos o índice de volta para o original
    // Itens: [0: Início, 1: Tarefas, 2: Favoritos]
    // Mapeia para: [0: Início, 2: Tarefas, 3: Favoritos]
    if (index == 1) {
      onTap(2); // Tarefas
    } else if (index == 2) {
      onTap(3); // Favoritos
    } else {
      onTap(0); // Início
    }
  }
}
