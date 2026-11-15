import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AppBottomNavigation extends StatelessWidget {
  final int indiceSelecionado;
  final ValueChanged<int> onTap;

  const AppBottomNavigation({
    super.key,
    required this.indiceSelecionado,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: indiceSelecionado,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      backgroundColor: AppColors.fundo,
      selectedItemColor: AppColors.verde,
      unselectedItemColor: AppColors.textoSecundario,
      selectedFontSize: 15,
      unselectedFontSize: 15,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: 'Início',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.description_outlined),
          label: 'Documentos',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_month_outlined),
          label: 'Consultas',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: 'Conta',
        ),
      ],
    );
  }
}
