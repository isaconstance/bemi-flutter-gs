import 'package:flutter/material.dart';
import '../models/consulta.dart';
import '../services/consulta_service.dart';

class ConsultaProvider extends ChangeNotifier {
  final ConsultaService _service = ConsultaService();

  List<Consulta> _consultas = [];
  bool _carregando = false;
  String? _erro;

  List<Consulta> get consultas => _consultas;
  bool get carregando => _carregando;
  String? get erro => _erro;

  Future<void> carregarConsultas() async {
    _carregando = true;
    _erro = null;
    notifyListeners();

    try {
      _consultas = await _service.buscarConsultas();
    } catch (e) {
      _erro = e.toString();
    } finally {
      _carregando = false;
      notifyListeners();
    }
  }
}
