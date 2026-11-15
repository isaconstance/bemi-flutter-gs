import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  String? _nome;
  String? _email;

  String? get nome => _nome;
  String? get email => _email;

  bool get temUsuario => _nome != null && _nome!.isNotEmpty;

  // Recupera os dados salvos no navegador.
  Future<void> carregarUsuario() async {
    final prefs = await SharedPreferences.getInstance();

    _nome = prefs.getString('usuario_nome');
    _email = prefs.getString('usuario_email');

    notifyListeners();
  }

  // Salva os dados básicos do cadastro.
  Future<void> cadastrar({required String nome, required String email}) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('usuario_nome', nome.trim());
    await prefs.setString('usuario_email', email.trim());

    _nome = nome.trim();
    _email = email.trim();

    notifyListeners();
  }

  Future<void> sair() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove('usuario_nome');
    await prefs.remove('usuario_email');

    _nome = null;
    _email = null;

    notifyListeners();
  }
}
