import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/documento_provider.dart';
import 'screens/splash_screen.dart';
import 'providers/consulta_provider.dart';
import 'providers/auth_provider.dart';
import 'package:bemi/theme/app_theme.dart';

void main() {
  runApp(const BemiApp());
}

class BemiApp extends StatelessWidget {
  const BemiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => DocumentoProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ConsultaProvider(),
        ),
        ChangeNotifierProvider(
        create: (_) => AuthProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'BEMI',
        theme: AppTheme.temaPrincipal,
        home: const SplashScreen(),
      ),
    );
  }
}
