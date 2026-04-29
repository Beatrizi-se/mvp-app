import 'package:flutter/material.dart';
import 'package:mobile/src/widgets/botao_opcao.dart';
import 'home_tdah.dart';

class TelaInicial extends StatelessWidget {
  const TelaInicial({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              const Text(
                'Como podemos te ajudar hoje?',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              const SizedBox(height: 12),
              Text(
                'Escolha o perfil para personalizarmos sua experiência.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 40),
              const BotaoOpcao(
                texto: 'TDAH',
                icone: Icons.bolt,
                destino: HomeTdah(),
              ),
              const Spacer(),
              const Divider(),
              TextButton(
                onPressed: () {},
                child: const Text('Fazer Login', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}