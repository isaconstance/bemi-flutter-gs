import 'package:flutter/material.dart';

class BemiHeader extends StatelessWidget {
  const BemiHeader({super.key});

  static const Color verde = Color(0xFF174F3B);
  static const Color dourado = Color(0xFFF2C879);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: verde,
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 22,
      ),
      child: Row(
        children: [
          Image.asset(
            'assets/images/logo_bemi.png',
            width: 58,
            height: 58,
            fit: BoxFit.contain,
          ),
          const SizedBox(width: 14),
          const Text(
            'BEMI',
            style: TextStyle(
              color: dourado,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Avisos em breve!'),
                ),
              );
            },
            icon: const Icon(
              Icons.notifications_none,
              color: Colors.white,
              size: 32,
            ),
          ),
        ],
      ),
    );
  }
}
