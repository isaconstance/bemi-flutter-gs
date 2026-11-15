import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../theme/app_theme.dart';
import 'login_screen.dart';

class ContaScreen extends StatelessWidget {
  const ContaScreen({super.key});

  Future<void> _sair(BuildContext context) async {
    await context.read<AuthProvider>().sair();

    if (!context.mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const LoginScreen(),
      ),
      (route) => false,
    );
  }

  void _mostrarMensagem(BuildContext context, String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensagem)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final usuario = context.watch<AuthProvider>();
    final primeiroNome = usuario.nome?.trim().split(RegExp(r'\s+')).first;

    return Scaffold(
      backgroundColor: AppColors.fundo,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 32, 24, 40),
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
                    'Minha conta',
                    style: TextStyle(
                      color: AppColors.verde,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 54),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.verdeClaro,
                  borderRadius: BorderRadius.circular(32),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 43,
                          backgroundColor: AppColors.branco,
                          child: Icon(
                            Icons.person_outline,
                            color: AppColors.verde,
                            size: 48,
                          ),
                        ),
                        const SizedBox(width: 18),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                usuario.temUsuario
                                    ? 'Olá, $primeiroNome!'
                                    : 'Bem-vindo(a)!',
                                style: const TextStyle(
                                  color: AppColors.verde,
                                  fontSize: 23,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Sua conta está conectada ao BEMI.',
                                style: TextStyle(
                                  color: AppColors.textoSecundario,
                                  fontSize: 16,
                                ),
                              ),
                              if (usuario.email != null) ...[
                                const SizedBox(height: 6),
                                Text(
                                  usuario.email!,
                                  style: const TextStyle(
                                    color: AppColors.textoSecundario,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),

                    SizedBox(
                      width: double.infinity,
                      height: 64,
                      child: ElevatedButton(
                        onPressed: () => _sair(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.verde,
                          foregroundColor: AppColors.branco,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(22),
                          ),
                        ),
                        child: const Text(
                          'Sair da minha conta',
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 48),

              const Text(
                'Personalização',
                style: TextStyle(
                  color: AppColors.verde,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 24),

              _opcao(
                context,
                icone: Icons.people_alt_outlined,
                titulo: 'Contatos familiares',
                subtitulo: 'Seus contatos de confiança',
              ),

              _opcao(
                context,
                icone: Icons.accessibility_new,
                titulo: 'Acessibilidade',
                subtitulo: 'Preferências de visualização',
              ),

              _opcao(
                context,
                icone: Icons.settings_outlined,
                titulo: 'Configurações',
                subtitulo: 'Preferências do aplicativo',
              ),

              const SizedBox(height: 36),

              const Text(
                'Sobre o aplicativo',
                style: TextStyle(
                  color: AppColors.verde,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 24),

              _opcao(
                context,
                icone: Icons.info_outline,
                titulo: 'Sobre o BEMI',
                subtitulo: 'Conheça nosso aplicativo',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _opcao(
    BuildContext context, {
    required IconData icone,
    required String titulo,
    required String subtitulo,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: InkWell(
        onTap: () => _mostrarMensagem(
          context,
          '$titulo estará disponível em breve!',
        ),
        borderRadius: BorderRadius.circular(20),
        child: Row(
          children: [
            CircleAvatar(
              radius: 31,
              backgroundColor: AppColors.verdeClaro,
              child: Icon(
                icone,
                color: AppColors.verde,
                size: 30,
              ),
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titulo,
                    style: const TextStyle(
                      color: AppColors.textoEscuro,
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitulo,
                    style: const TextStyle(
                      color: AppColors.textoSecundario,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
