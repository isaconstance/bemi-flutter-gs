import 'package:flutter/material.dart';
import '../models/documento.dart';
import '../services/documento_service.dart';

class DocumentoProvider extends ChangeNotifier {
  final DocumentoService _service = DocumentoService();

  List<Documento> _documentos = [];
  bool _carregando = false;
  String? _erro;

  List<Documento> get documentos => _documentos;
  bool get carregando => _carregando;
  String? get erro => _erro;

  Future<void> carregarDocumentos() async {
    _carregando = true;
    _erro = null;
    notifyListeners();

    try {
      _documentos = await _service.buscarDocumentos();
    } catch (e) {
      _erro = e.toString();
    } finally {
      _carregando = false;
      notifyListeners();
    }
  }

  Future<void> cadastrarDocumento({
    required String tipo,
    String? validade,
    required String status,
    required String observacao,
  }) async {
    final novoId = _documentos.isEmpty
        ? 1
        : _documentos
                .map((doc) => doc.id)
                .reduce((a, b) => a > b ? a : b) +
            1;

    final documento = Documento(
      id: novoId,
      tipo: tipo,
      validade: validade,
      status: status,
      observacao: observacao,
    );

    final listaAtualizada = [..._documentos, documento];

    await _service.salvarDocumentos(listaAtualizada);

    _documentos = listaAtualizada;
    notifyListeners();
  }

  Future<void> editarDocumento(Documento documentoAtualizado) async {
    final listaAtualizada = _documentos.map((doc) {
      return doc.id == documentoAtualizado.id
          ? documentoAtualizado
          : doc;
    }).toList();

    await _service.salvarDocumentos(listaAtualizada);

    _documentos = listaAtualizada;
    notifyListeners();
  }

  Future<void> excluirDocumento(int id) async {
    final listaAtualizada = _documentos
        .where((doc) => doc.id != id)
        .toList();

    await _service.salvarDocumentos(listaAtualizada);

    _documentos = listaAtualizada;
    notifyListeners();
  }
}
