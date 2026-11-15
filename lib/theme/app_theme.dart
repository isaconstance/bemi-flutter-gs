import 'package:flutter/material.dart';

class AppColors {
  static const Color verde = Color(0xFF174F3B);
  static const Color verdeClaro = Color(0xFFE8ECD9);
  static const Color dourado = Color(0xFFF2C879);
  static const Color fundo = Color(0xFFFFF5E9);
  static const Color branco = Colors.white;
  static const Color vermelho = Color(0xFFC62828);
  static const Color texto = Color(0xFF333333);
  static const Color cinza = Color(0xFF757575);
  static const Color verdeStatus = Color(0xFF287A4D);
  static const Color douradoStatus = Color(0xFFB7791F);
  static const Color vermelhoStatus = Color(0xFFC0392B);
  static const Color vermelhoEmergencia = Color(0xFFCF332D);
  static const Color textoEscuro = Color(0xFF292F29);
  static const Color textoSecundario = Color(0xFF68736A);
  static const Color textoTitulo = Color(0xFF252D27);
  static const Color pretoSecundario = Colors.black87;
  static const Color pretoSuave = Colors.black54;
  static const Color fundoDocumentos = Color(0xFFF8F8F3);
}

class AppTheme {
  static ThemeData get temaPrincipal {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.fundo,

      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.verde,
        primary: AppColors.verde,
        secondary: AppColors.dourado,
        surface: AppColors.branco,
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.fundo,
        foregroundColor: AppColors.verde,
        elevation: 0,
        centerTitle: false,
      ),
    );
  }
}
