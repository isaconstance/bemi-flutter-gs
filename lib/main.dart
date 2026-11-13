
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/documento_provider.dart';
import 'screens/splash_screen.dart';

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
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'BEMI',
        home: const SplashScreen(),
      ),
    );
  }
}
