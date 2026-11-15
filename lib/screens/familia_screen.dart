
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class FamiliaScreen extends StatelessWidget {
  const FamiliaScreen({super.key});

  final List<Map<String, String>> contatos = const [
    {'nome': 'Ana', 'telefone': '(11) 00000-0000'},
    {'nome': 'Carlos', 'telefone': '(11) 00000-0001'},
  ];

  Widget _contatoCard(Map<String, String> contato) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 20,
      ),
      decoration: BoxDecoration(
        color: AppColors.branco,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.10),
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 27,
            backgroundColor: AppColors.verdeClaro,
            child: const Icon(
              Icons.person_outline,
              color: AppColors.verde,
              size: 32,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  contato['nome']!,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textoTitulo,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  contato['telefone']!,
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppColors.textoSecundario,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            style: IconButton.styleFrom(
              backgroundColor: AppColors.verde,
              foregroundColor: AppColors.branco,
              minimumSize: const Size(54, 54),
            ),
            icon: const Icon(Icons.phone),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fundo,
      appBar: AppBar(
        backgroundColor: AppColors.fundo,
        foregroundColor: AppColors.verde,
        elevation: 0,
        title: const Text(
          'Meus Contatos',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.vermelhoEmergencia.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(22),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    color: AppColors.vermelhoEmergencia,
                    size: 38,
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      'Este aplicativo não substitui os serviços oficiais de emergência.',
                      style: TextStyle(
                        color: AppColors.vermelhoStatus,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 35),
            const Text(
              'Seus contatos familiares',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.textoTitulo,
              ),
            ),
            const SizedBox(height: 20),

            ...contatos.map(_contatoCard),

            const SizedBox(height: 45),

            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: AppColors.branco,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Precisa de atendimento médico?',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textoTitulo,
                          ),
                        ),
                        const SizedBox(height: 14),
                        const Text(
                          'SAMU · 192',
                          style: TextStyle(
                            color: AppColors.vermelhoEmergencia,
                            fontSize: 27,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Serviço de atendimento móvel de urgência',
                          style: TextStyle(
                            color: AppColors.cinza,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    onPressed: () {},
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.vermelhoEmergencia,
                      foregroundColor: AppColors.branco,
                      minimumSize: const Size(62, 62),
                    ),
                    icon: const Icon(
                      Icons.phone,
                      size: 28,
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
