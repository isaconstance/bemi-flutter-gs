
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/documento.dart';

class DocumentoService {
  static const String _baseUrl = 'https://api.jsonbin.io/v3/b';

  static const String _binId = '6af67e3cffd5d16053bdabd2';
  static const String _accessKey = r'$2a$10$WrSFiOGun8AVyCm6624qru4IJlSEDDNaJPbLUsILyWjmuDuq6I/jW';

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'X-Access-Key': _accessKey,
  };

  Future<List<Documento>> buscarDocumentos() async {
    final url = Uri.parse('$_baseUrl/$_binId/latest');

    final response = await http.get(
      url,
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final dados = jsonDecode(response.body);
      final List lista = dados['record']['documentos'];

      return lista
          .map((item) => Documento.fromJson(item))
          .toList();
    }

    throw Exception(
      'Erro ao buscar documentos: ${response.statusCode} - ${response.body}',
    );
  }

  Future<void> salvarDocumentos(List<Documento> documentos) async {
    final url = Uri.parse('$_baseUrl/$_binId');

    final response = await http.put(
      url,
      headers: _headers,
      body: jsonEncode({
        'documentos': documentos.map((doc) => doc.toJson()).toList(),
      }),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Erro ao salvar documentos: ${response.statusCode} - ${response.body}',
      );
    }
  }
}
