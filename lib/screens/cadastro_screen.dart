import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../theme/app_theme.dart';
import 'home_screen.dart';

class CadastroScreen extends StatefulWidget {
  const CadastroScreen({super.key});

  @override
  State<CadastroScreen> createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _confirmarSenhaController = TextEditingController();
  final _sobrenomeController = TextEditingController();

  bool _mostrarSenha = false;
  bool _mostrarConfirmarSenha = false;

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _senhaController.dispose();
    _confirmarSenhaController.dispose();
    _sobrenomeController.dispose();
    super.dispose();
  }

  Future<void> _criarConta() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    await context.read<AuthProvider>().cadastrar(
      nome: '${_nomeController.text.trim()} ${_sobrenomeController.text.trim()}',
      email: _emailController.text,
    );

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const HomeScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fundo,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.arrow_back,
                        color: AppColors.verde,
                        size: 32,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'BEMI',
                      style: TextStyle(
                        color: AppColors.verde,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                const Text(
                  'Vamos criar sua conta?',
                  style: TextStyle(
                    color: AppColors.textoSecundario,
                    fontSize: 21,
                  ),
                ),

                const SizedBox(height: 24),

                const Center(
                  child: Text(
                    'Preencha seus dados para começar.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.textoSecundario,
                      fontSize: 19,
                    ),
                  ),
                ),

                const SizedBox(height: 62),

                TextFormField(
                  controller: _nomeController,
                  textCapitalization: TextCapitalization.words,
                  decoration: _decoracaoCampo('Nome'),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Informe seu nome';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 24),

                TextFormField(
                  controller: _sobrenomeController,
                  textCapitalization: TextCapitalization.words,
                  decoration: _decoracaoCampo('Sobrenome'),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Informe seu sobrenome';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 24),

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
                    'Crie uma senha',
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
                        color: AppColors.pretoSecundario,
                        size: 26,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Crie uma senha';
                    }

                    if (value.length < 6) {
                      return 'A senha deve ter pelo menos 6 caracteres';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 24),

                TextFormField(
                  controller: _confirmarSenhaController,
                  obscureText: !_mostrarConfirmarSenha,
                  decoration: _decoracaoCampo(
                    'Confirme sua senha',
                    sufixo: IconButton(
                      onPressed: () {
                        setState(() {
                          _mostrarConfirmarSenha =
                              !_mostrarConfirmarSenha;
                        });
                      },
                      icon: Icon(
                        _mostrarConfirmarSenha
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: AppColors.pretoSecundario,
                        size: 26,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Confirme sua senha';
                    }

                    if (value != _senhaController.text) {
                      return 'As senhas não coincidem';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 32),

                SizedBox(
                  width: double.infinity,
                  height: 72,
                  child: ElevatedButton(
                    onPressed: _criarConta,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.verde,
                      foregroundColor: AppColors.branco,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22),
                      ),
                    ),
                    child: const Text(
                      'Criar minha conta',
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
                        'Já tem uma conta? ',
                        style: TextStyle(
                          color: AppColors.textoSecundario,
                          fontSize: 17,
                        ),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          'Entrar',
                          style: TextStyle(
                            color: AppColors.verde,
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

  InputDecoration _decoracaoCampo(String titulo, {Widget? sufixo}) {
    return InputDecoration(
      hintText: titulo,
      hintStyle: const TextStyle(
        color: AppColors.pretoSecundario,
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
          color: AppColors.cinza,
          width: 1.5,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(23),
        borderSide: const BorderSide(
          color: AppColors.verde,
          width: 2,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(23),
        borderSide: const BorderSide(color: AppColors.vermelho),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(23),
        borderSide: const BorderSide(
          color: AppColors.vermelho,
          width: 2,
        ),
      ),
    );
  }
}
