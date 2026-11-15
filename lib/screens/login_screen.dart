import 'package:flutter/material.dart';
import 'cadastro_screen.dart';
import 'home_screen.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();

  bool _mostrarSenha = false;

  static const Color verde = Color(0xFF174F3B);
  static const Color fundo = Color(0xFFFFF5E9);
  static const Color texto = Color(0xFF6B716A);
  static const Color borda = Color(0xFF88818A);

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  Future<void> _entrar() async {
  if (!_formKey.currentState!.validate()) {
    return;
  }

  final authProvider = context.read<AuthProvider>();

  await authProvider.carregarUsuario();

  if (!mounted) return;

  final emailDigitado = _emailController.text.trim().toLowerCase();
  final emailCadastrado = authProvider.email?.trim().toLowerCase();

  if (emailCadastrado == null || emailDigitado != emailCadastrado) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('E-mail não encontrado. Verifique seus dados ou cadastre-se.'),
      ),
    );
    return;
  }

  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (_) => const HomeScreen(),
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fundo,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 32,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        if (Navigator.canPop(context)) {
                          Navigator.pop(context);
                        }
                      },
                      icon: const Icon(
                        Icons.arrow_back,
                        color: verde,
                        size: 32,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'BEMI',
                      style: TextStyle(
                        color: verde,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 42),

                const Text(
                  'Que bom ter você de volta!',
                  style: TextStyle(
                    color: texto,
                    fontSize: 21,
                  ),
                ),

                const SizedBox(height: 30),

                const Center(
                  child: Text(
                    'Entre na sua conta para acessar suas informações.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: texto,
                      fontSize: 19,
                      height: 1.5,
                    ),
                  ),
                ),

                const SizedBox(height: 105),

                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: _decoracaoCampo('E-mail'),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Informe seu e-mail';
                    }

                    if (!value.contains('@') || !value.contains('.')) {
                      return 'Informe um e-mail válido';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 24),

                TextFormField(
                  controller: _senhaController,
                  obscureText: !_mostrarSenha,
                  decoration: _decoracaoCampo(
                    'Senha',
                    sufixo: IconButton(
                      onPressed: () {
                        setState(() {
                          _mostrarSenha = !_mostrarSenha;
                        });
                      },
                      icon: Icon(
                        _mostrarSenha
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: const Color(0xFF514B55),
                        size: 26,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Informe sua senha';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 32),

                SizedBox(
                  width: double.infinity,
                  height: 72,
                  child: ElevatedButton(
                    onPressed: _entrar,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: verde,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22),
                      ),
                    ),
                    child: const Text(
                      'Entrar',
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 48),

                Center(
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      const Text(
                        'Ainda não tem uma conta? ',
                        style: TextStyle(
                          color: texto,
                          fontSize: 17,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const CadastroScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          'Cadastre-se',
                          style: TextStyle(
                            color: verde,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _decoracaoCampo(
    String titulo, {
    Widget? sufixo,
  }) {
    return InputDecoration(
      hintText: titulo,
      hintStyle: const TextStyle(
        color: Color(0xFF514B55),
        fontSize: 19,
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 25,
      ),
      suffixIcon: sufixo,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(23),
        borderSide: const BorderSide(
          color: borda,
          width: 1.5,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(23),
        borderSide: const BorderSide(
          color: verde,
          width: 2,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(23),
        borderSide: const BorderSide(
          color: Colors.red,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(23),
        borderSide: const BorderSide(
          color: Colors.red,
          width: 2,
        ),
      ),
    );
  }
}
