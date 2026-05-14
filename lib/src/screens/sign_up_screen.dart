import 'package:flutter/material.dart';
import '../widgets/app_text_field.dart';
import '../widgets/app_button.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _acceptedTerms = false;

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
                  'Crie sua conta,\nvamos começar?',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              // Campo de Nome
              const AppTextField(
                label: 'Nome completo:',
                hintText: 'Digite seu nome',
                suffixIcon: Icons.person_outline,
              ),
              const SizedBox(height: 20),
              // Campo de E-mail
              const AppTextField(
                label: 'E-mail:',
                hintText: 'seu@email.com',
                suffixIcon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),
              // Campo de Senha
              const AppTextField(
                label: 'Senha:',
                hintText: 'Sua senha',
                isPassword: true,
              ),
              const SizedBox(height: 16),
              // Termos de Serviço
              Row(
                children: [
                  SizedBox(
                    height: 24,
                    width: 24,
                    child: Checkbox(
                      value: _acceptedTerms,
                      onChanged: (value) {
                        setState(() {
                          _acceptedTerms = value ?? false;
                        });
                      },
                      activeColor: theme.colorScheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _acceptedTerms = !_acceptedTerms;
                        });
                      },
                      child: RichText(
                        text: TextSpan(
                          style: theme.textTheme.bodySmall?.copyWith(color: Colors.black87),
                          children: [
                            const TextSpan(text: 'Eu aceito os '),
                            TextSpan(
                              text: 'termos de serviço',
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
                ],
              ),
              const SizedBox(height: 32),
              // Botão Cadastrar usando AppButton
              AppButton(
                text: 'Cadastrar',
                onPressed: _acceptedTerms 
                    ? () {
                        // TODO: Lógica de cadastro
                        Navigator.of(context).pushReplacementNamed('/home');
                      }
                    : () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Por favor, aceite os termos de serviço.')),
                        );
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
              // Botão Google usando AppButton
              AppButton(
                text: 'Entrar com Google',
                type: AppButtonType.outlined,
                leftIcon: const Icon(Icons.account_circle_outlined, color: Colors.red, size: 20),
                onPressed: () {
                  // TODO: Lógica de cadastro com Google
                },
              ),
              const SizedBox(height: 32),
              // Link para login
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/');
                },
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: theme.textTheme.bodyMedium?.copyWith(color: Colors.black54),
                    children: [
                      const TextSpan(text: 'Já tenho um login!\n'),
                      TextSpan(
                        text: 'Entrar aqui!',
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
