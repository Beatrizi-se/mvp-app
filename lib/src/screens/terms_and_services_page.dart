import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/app_header.dart';

class TermsAndServicesPage extends StatelessWidget {
  const TermsAndServicesPage({super.key});

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
              'Termos de Uso e Política de Privacidade',
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Última atualização: Maio de 2024',
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 24),
            _buildSection(
              '1. Aceitação dos Termos',
              'Ao utilizar o aplicativo Pato, você concorda em cumprir e aceitar estes termos e condições. Este aplicativo foi desenvolvido para auxiliar na organização de tarefas e gamificação de rotinas.',
            ),
            _buildSection(
              '2. Privacidade e LGPD',
              'Em conformidade com a Lei Geral de Proteção de Dados (Lei nº 13.709/2018), informamos que coletamos apenas os dados necessários para o funcionamento do app (como nome e e-mail). Seus dados não serão compartilhados com terceiros sem seu consentimento expresso.',
            ),
            _buildSection(
              '3. Uso do Conteúdo',
              'As sugestões de tarefas e dicas geradas por IA são para fins informativos. O usuário é responsável por validar e executar suas próprias atividades.',
            ),
            _buildSection(
              '4. Contas de Usuário',
              'Você é responsável por manter a confidencialidade de sua senha e por todas as atividades que ocorrem em sua conta.',
            ),
            _buildSection(
              '5. Modificações',
              'Reservamo-nos o direito de modificar estes termos a qualquer momento. Alterações significativas serão notificadas através do próprio aplicativo.',
            ),
            _buildSection(
              '6. Contato',
              'Para questões relacionadas à privacidade ou exclusão de dados, entre em contato através do e-mail: suporte@patoapp.com.br',
            ),
            const SizedBox(height: 40),
            Center(
              child: Image.asset(
                'assets/pato_logo.png',
                height: 60,
                opacity: const AlwaysStoppedAnimation(0.5),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF6C63FF),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            textAlign: TextAlign.justify,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.black87,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
