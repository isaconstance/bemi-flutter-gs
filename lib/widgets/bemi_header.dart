import 'package:flutter/material.dart';
import '../screens/avisos_screen.dart';
import '../theme/app_theme.dart';

class BemiHeader extends StatelessWidget {
  const BemiHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.verde,
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
              color: AppColors.dourado,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AvisosScreen(),
                ),
              );
            },
            icon: const Icon(
              Icons.notifications_none,
              color: AppColors.branco,
              size: 32,
            ),
          ),
        ],
      ),
    );
  }
}
