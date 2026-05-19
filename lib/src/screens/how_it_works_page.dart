import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/app_header.dart';

class HowItWorksPage extends StatelessWidget {
  const HowItWorksPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppHeader(
        onLeadingPressed: () => Navigator.pop(context),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Como funciona?',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 24),
            _buildStep(
              context,
              number: '1',
              title: 'Organize suas ideias',
              description: 'Use a aba de Tarefas para listar o que precisa fazer. O Pato te ajuda a não esquecer nada.',
              icon: Icons.lightbulb_outline_rounded,
            ),
            _buildStep(
              context,
              number: '2',
              title: 'Divida e conquiste',
              description: 'O segredo é quebrar tarefas grandes em passos bem pequenos. Isso torna tudo menos assustador.',
              icon: Icons.account_tree_outlined,
            ),
            _buildStep(
              context,
              number: '3',
              title: 'Modo Foco',
              description: 'Quando precisar de silêncio visual, ative o Modo Foco para esconder distrações e focar no agora.',
              icon: Icons.visibility_off_outlined,
            ),
            _buildStep(
              context,
              number: '4',
              title: 'Gamificação',
              description: 'Ganhe recompensas e divirta-se na aba de Jogos enquanto mantém sua rotina em dia.',
              icon: Icons.videogame_asset_outlined,
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: theme.colorScheme.primary.withOpacity(0.2)),
              ),
              child: Column(
                children: [
                  const Text(
                    'Dica de Ouro 🦆',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Se uma tarefa parecer impossível, divida-a em passos ainda menores até que o primeiro passo seja fácil demais para não ser feito!',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(fontSize: 14, height: 1.5),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildStep(BuildContext context, {required String number, required String title, required String description, required IconData icon}) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 32.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              number,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(icon, size: 20, color: theme.colorScheme.primary),
                    const SizedBox(width: 8),
                    Text(
                      title,
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.black54,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
