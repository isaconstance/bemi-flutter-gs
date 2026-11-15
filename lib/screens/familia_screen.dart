import 'package:flutter/material.dart';

class FamiliaScreen extends StatelessWidget {
  const FamiliaScreen({super.key});

  static const Color verde = Color(0xFF174F3B);
  static const Color fundo = Color(0xFFFFF5E9);
  static const Color verdeClaro = Color(0xFFE8ECD9);
  static const Color vermelho = Color(0xFFE53935);

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
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.10),
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 27,
            backgroundColor: verdeClaro,
            child: const Icon(
              Icons.person_outline,
              color: verde,
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
                    color: Color(0xFF252B25),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  contato['telefone']!,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF70786F),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            style: IconButton.styleFrom(
              backgroundColor: verde,
              foregroundColor: Colors.white,
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
      backgroundColor: fundo,
      appBar: AppBar(
        backgroundColor: fundo,
        foregroundColor: verde,
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
                color: const Color(0xFFFBE5E2),
                borderRadius: BorderRadius.circular(22),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    color: vermelho,
                    size: 38,
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      'Este aplicativo não substitui os serviços oficiais de emergência.',
                      style: TextStyle(
                        color: Color(0xFF963B32),
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
                color: Color(0xFF252B25),
              ),
            ),
            const SizedBox(height: 20),

            ...contatos.map(_contatoCard),

            const SizedBox(height: 45),

            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: Colors.white,
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
                            color: Color(0xFF252B25),
                          ),
                        ),
                        const SizedBox(height: 14),
                        const Text(
                          'SAMU · 192',
                          style: TextStyle(
                            color: vermelho,
                            fontSize: 27,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Serviço de atendimento móvel de urgência',
                          style: TextStyle(
                            color: Colors.grey.shade600,
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
                      backgroundColor: vermelho,
                      foregroundColor: Colors.white,
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

            const SizedBox(height: 25),

            Text(
              'Ao tocar no telefone, você poderá confirmar a ligação no aplicativo de chamadas.',
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 15,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
