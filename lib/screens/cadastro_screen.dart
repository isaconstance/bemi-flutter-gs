import 'package:flutter/material.dart';

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

  bool _mostrarSenha = false;
  bool _mostrarConfirmarSenha = false;

  static const Color verde = Color(0xFF174F3B);
  static const Color fundo = Color(0xFFFFF5E9);
  static const Color texto = Color(0xFF6B716A);
  static const Color borda = Color(0xFF88818A);

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _senhaController.dispose();
    _confirmarSenhaController.dispose();
    super.dispose();
  }

  void _criarConta() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('O cadastro será conectado em breve!'),
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
                      onPressed: () => Navigator.pop(context),
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

                const SizedBox(height: 24),

                const Text(
                  'Vamos criar sua conta?',
                  style: TextStyle(
                    color: texto,
                    fontSize: 21,
                  ),
                ),

                const SizedBox(height: 24),

                const Center(
                  child: Text(
                    'Preencha seus dados para começar.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: texto,
                      fontSize: 19,
                    ),
                  ),
                ),

                const SizedBox(height: 62),

                TextFormField(
                  controller: _nomeController,
                  textCapitalization: TextCapitalization.words,
                  decoration: _decoracaoCampo('Nome completo'),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Informe seu nome completo';
                    }

                    if (value.trim().split(' ').length < 2) {
                      return 'Informe seu nome e sobrenome';
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
                        color: const Color(0xFF514B55),
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
                        color: const Color(0xFF514B55),
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
                      backgroundColor: verde,
                      foregroundColor: Colors.white,
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
                          color: texto,
                          fontSize: 17,
                        ),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          'Entrar',
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
