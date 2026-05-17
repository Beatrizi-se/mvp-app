import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/app_text_field.dart';
import '../widgets/app_button.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('E-mail ou senha não encontrados. Por favor, crie uma conta se ainda não tiver uma.'),
          backgroundColor: Colors.orange,
          duration: Duration(seconds: 5),
        ),
      );
      return;
    }

    try {
      await authProvider.login(email, password);
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/home');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro: Credenciais inválidas. Se você é novo por aqui, cadastre-se!'),
            backgroundColor: Colors.redAccent,
            action: SnackBarAction(
              label: 'CADASTRAR',
              textColor: Colors.white,
              onPressed: () => Navigator.of(context).pushNamed('/signup'),
            ),
            duration: Duration(seconds: 6),
          ),
        );
      }
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
                  'Bom te ver,\npor onde começamos?',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 32),
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
              const SizedBox(height: 12),
              // Esqueci a senha
              Align(
                alignment: Alignment.center,
                child: TextButton(
                  onPressed: () {},
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
              authProvider.isLoading
                  ? const CircularProgressIndicator()
                  : AppButton(
                      text: 'Entrar',
                      onPressed: _handleLogin,
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
