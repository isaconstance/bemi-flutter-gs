import 'package:flutter/material.dart';

class AssistenteCard extends StatelessWidget {
  const AssistenteCard({super.key});

  static const Color verde = Color(0xFF174F3B);
  static const Color fundoCard = Color(0xFFE8ECD9);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: fundoCard,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Image.asset(
                  'assets/images/bemi_robot.png',
                  height: 165,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                flex: 3,
                child: Text(
                  'Como posso\nte ajudar hoje?',
                  style: TextStyle(
                    color: verde,
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                    height: 1.3,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 64,
            child: ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Assistente BEMI em breve!'),
                  ),
                );
              },
              icon: const Icon(Icons.mic, size: 28),
              label: const Text(
                'Falar com o BEMI',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: verde,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
