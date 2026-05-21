import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/app_text_field.dart';
import '../widgets/app_button.dart';
import '../providers/auth_provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _acceptedTerms = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignUp() async {
    if (!_acceptedTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, aceite os termos de serviço.')),
      );
      return;
    }

    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, preencha todos os campos.')),
      );
      return;
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    try {
      await authProvider.register(name, email, password);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cadastro realizado com sucesso! Faça login para continuar.')),
      );
      // Retorna para a tela de login
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceAll('Exception: ', ''))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authProvider = Provider.of<AuthProvider>(context);

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
                  Image.asset('assets/pato_logo.png', height: 150, errorBuilder: (context, error, stackTrace) => const Icon(Icons.image_not_supported, size: 100)),
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
              AppTextField(
                label: 'Nome completo:',
                hintText: 'Digite seu nome',
                suffixIcon: Icons.person_outline,
                controller: _nameController,
              ),
              const SizedBox(height: 20),
              // Campo de E-mail
              AppTextField(
                label: 'E-mail:',
                hintText: 'seu@email.com',
                suffixIcon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                controller: _emailController,
              ),
              const SizedBox(height: 20),
              // Campo de Senha
              AppTextField(
                label: 'Senha:',
                hintText: 'Sua senha',
                isPassword: true,
                controller: _passwordController,
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
                    child: RichText(
                      text: TextSpan(
                        style: theme.textTheme.bodySmall?.copyWith(color: Colors.black87),
                        children: [
                          TextSpan(
                            text: 'Eu aceito os ',
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                setState(() {
                                  _acceptedTerms = !_acceptedTerms;
                                });
                              },
                          ),
                          TextSpan(
                            text: 'termos de serviço',
                            style: TextStyle(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.pushNamed(context, '/terms');
                              },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              // Botão Cadastrar
              authProvider.isLoading
                  ? const CircularProgressIndicator()
                  : AppButton(
                      text: 'Cadastrar',
                      onPressed: _handleSignUp,
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
                  Navigator.of(context).pop();
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
