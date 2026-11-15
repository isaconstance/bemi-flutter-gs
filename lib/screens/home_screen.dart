
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../theme/app_theme.dart';
import '../widgets/bemi_header.dart';
import '../widgets/assistente_card.dart';
import '../widgets/atalho_card.dart';
import '../widgets/app_bottom_navigation.dart';
import '../providers/auth_provider.dart';
import '../providers/documento_provider.dart';
import '../providers/consulta_provider.dart';

import 'documentos_screen.dart';
import 'consultas_screen.dart';
import 'conta_screen.dart';
import 'avisos_screen.dart';
import 'familia_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<AuthProvider>().carregarUsuario();
        context.read<DocumentoProvider>().carregarDocumentos();
        context.read<ConsultaProvider>().carregarConsultas();
      }
    });
  }

  void _navegar(int indice) {
    if (indice == 0) return;

    if (indice == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const DocumentosScreen()),
      );
      return;
    }

    if (indice == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const ConsultasScreen()),
      );
      return;
    }

    if (indice == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const ContaScreen()),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Minha conta em breve!')),
    );
  }

  void _abrirFuncionalidade(String nome) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$nome estará disponível em breve!')),
    );
  }

  Widget _cardOds() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.verdeClaro,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.verde,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'ODS 3',
                  style: TextStyle(
                    color: AppColors.branco,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  'Saúde e Bem-Estar',
                  style: TextStyle(
                    color: AppColors.verde,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Promover uma vida saudável e o bem-estar para todos, '
            'em todas as idades.',
            style: TextStyle(
              color: AppColors.verde,
              fontSize: 14,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'O BEMI contribui para esse objetivo facilitando o '
            'acompanhamento de consultas, o acesso a informações '
            'de saúde e a autonomia das pessoas idosas.',
            style: TextStyle(
              color: AppColors.verde,
              fontSize: 13,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final usuario = context.watch<AuthProvider>();
    final documentos = context.watch<DocumentoProvider>();
    final consultas = context.watch<ConsultaProvider>();
    final primeiroNome = usuario.nome?.trim().split(RegExp(r'\s+')).first;

    return Scaffold(
      backgroundColor: AppColors.fundo,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const BemiHeader(),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: AppColors.fundo,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(40),
                  ),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 28, 24, 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        usuario.temUsuario
                            ? 'Olá, $primeiroNome!'
                            : 'Bem-vindo(a) ao BEMI!',
                        style: const TextStyle(
                          color: AppColors.verde,
                          fontSize: 29,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Que bom ter você por aqui!',
                        style: TextStyle(
                          color: Color(0xFF292F29),
                          fontSize: 19,
                        ),
                      ),
                      const SizedBox(height: 30),
                      const AssistenteCard(),
                      const SizedBox(height: 20),
                      _cardOds(),
                      const SizedBox(height: 24),
                      const Text(
                        'Resumo',
                        style: TextStyle(
                          color: AppColors.verde,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          _cardIndicador(
                            icone: Icons.description_outlined,
                            titulo: 'Documentos cadastrados',
                            valor: documentos.carregando
                                ? '...'
                                : documentos.erro != null
                                    ? '—'
                                    : documentos.documentos.length.toString(),
                          ),
                          const SizedBox(width: 14),
                          _cardIndicador(
                            icone: Icons.calendar_month_outlined,
                            titulo: 'Consultas registradas',
                            valor: consultas.carregando
                                ? '...'
                                : consultas.erro != null
                                    ? '—'
                                    : consultas.consultas.length.toString(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 28),
                      GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisSpacing: 14,
                        mainAxisSpacing: 14,
                        childAspectRatio: 1.45,
                        children: [
                          AtalhoCard(
                            icone: Icons.description_outlined,
                            titulo: 'Documentos',
                            onTap: () => _navegar(1),
                          ),
                          AtalhoCard(
                            icone: Icons.calendar_month_outlined,
                            titulo: 'Consultas',
                            onTap: () => _navegar(2),
                          ),
                          AtalhoCard(
                            icone: Icons.notifications_none,
                            titulo: 'Avisos',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const AvisosScreen(),
                                ),
                              );
                            },
                          ),
                          AtalhoCard(
                            icone: Icons.groups_outlined,
                            titulo: 'Família',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const FamiliaScreen(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 22),
                      SizedBox(
                        width: double.infinity,
                        height: 88,
                        child: ElevatedButton(
                          onPressed: () {
                            _abrirFuncionalidade('Emergência');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFCF332D),
                            foregroundColor: AppColors.branco,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28),
                            ),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.call, size: 32),
                              SizedBox(width: 18),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Emergência',
                                    style: TextStyle(
                                      fontSize: 21,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'Ligue 192',
                                    style: TextStyle(fontSize: 17),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNavigation(
        indiceSelecionado: 0,
        onTap: _navegar,
      ),
    );
  }

  Widget _cardIndicador({
    required IconData icone,
    required String titulo,
    required String valor,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.branco,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icone, color: AppColors.verde, size: 28),
            const SizedBox(height: 12),
            Text(
              valor,
              style: const TextStyle(
                color: AppColors.verde,
                fontSize: 27,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              titulo,
              style: const TextStyle(
                color: Color(0xFF292F29),
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
