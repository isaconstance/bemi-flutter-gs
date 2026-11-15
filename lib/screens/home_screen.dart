import 'package:flutter/material.dart';
import '../widgets/bemi_header.dart';
import '../widgets/assistente_card.dart';
import '../widgets/atalho_card.dart';
import '../widgets/app_bottom_navigation.dart';
import 'documentos_screen.dart';
import 'consultas_screen.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'conta_screen.dart';
import 'avisos_screen.dart';
import 'familia_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const Color verde = Color(0xFF174F3B);
  static const Color fundo = Color(0xFFFFF5E9);

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<AuthProvider>().carregarUsuario();
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

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Minha conta em breve!')));
  }

  void _abrirFuncionalidade(String nome) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$nome estará disponível em breve!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final usuario = context.watch<AuthProvider>();
    final primeiroNome = usuario.nome?.trim().split(RegExp(r'\s+')).first;

    return Scaffold(
      backgroundColor: fundo,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const BemiHeader(),

            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: fundo,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
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
                          color: verde,
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
                                  builder: (context) => const FamiliaScreen(),
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
                            foregroundColor: Colors.white,
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
}
