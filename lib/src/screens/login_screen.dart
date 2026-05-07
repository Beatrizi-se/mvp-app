import 'package:flutter/material.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/primary_button.dart';
import '../widgets/google_button.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FF),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              // Logo "PATO"
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/pato_logo.png', height: 150),
                ],
              ),
              const SizedBox(height: 40),
              // Texto de saudação
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Bom te ver,\npor onde começamos?',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              // Campo de E-mail
              const CustomTextField(
                label: 'E-mail:',
                hintText: 'seu@email.com',
                suffixIcon: Icons.email_outlined,
              ),
              const SizedBox(height: 20),
              // Campo de Senha
              const CustomTextField(
                label: 'Senha:',
                hintText: 'Sua senha',
                isPassword: true,
                suffixIcon: Icons.visibility_outlined,
              ),
              const SizedBox(height: 12),
              // Esqueci a senha
              Align(
                alignment: Alignment.center,
                child: TextButton(
                  onPressed: () {
                    // TODO: Navegar para recuperação de senha
                  },
                  child: RichText(
                    text: TextSpan(
                      style: theme.textTheme.bodySmall?.copyWith(color: Colors.black54),
                      children: [
                        const TextSpan(text: 'Esqueceu a senha? '),
                        TextSpan(
                          text: 'recuperar senha!',
                          style: TextStyle(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Botão Entrar
              PrimaryButton(
                text: 'Entrar',
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed('/home');
                },
              ),
              const SizedBox(height: 16),
              // Divisor "ou"
              const Row(
                children: [
                  Expanded(child: Divider(color: Colors.black12)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text('ou', style: TextStyle(color: Colors.black38)),
                  ),
                  Expanded(child: Divider(color: Colors.black12)),
                ],
              ),
              const SizedBox(height: 16),
              // Botão Google
              GoogleButton(
                onPressed: () {
                  // TODO: Lógica de login com Google
                },
              ),
              const SizedBox(height: 32),
              // Link para cadastro
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/signup');
                },
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: theme.textTheme.bodyMedium?.copyWith(color: Colors.black54),
                    children: [
                      const TextSpan(text: 'Não tem uma conta?\n'),
                      TextSpan(
                        text: 'Crie uma conta aqui!',
                        style: TextStyle(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
