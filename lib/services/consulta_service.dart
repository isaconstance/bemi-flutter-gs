import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/consulta.dart';

class ConsultaService {
  static const String _baseUrl = 'https://api.jsonbin.io/v3/b';
  static const String _binId = '6aee96c9ac6210605a744115';

  // Utilize a mesma chave já configurada no DocumentoService.
  static const String _accessKey = r'$2a$10$WrSFiOGun8AVyCm6624qru4IJlSEDDNaJPbLUsILyWjmuDuq6I/jW';

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'X-Access-Key': _accessKey,
  };

  Future<List<Consulta>> buscarConsultas() async {
    final url = Uri.parse('$_baseUrl/$_binId/latest');

    final response = await http.get(
      url,
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final dados = jsonDecode(response.body);
      final List lista = dados['record']['consultas'];

      return lista
          .map((item) => Consulta.fromJson(item))
          .toList();
    }

    throw Exception(
      'Erro ao buscar consultas: ${response.statusCode} - ${response.body}',
    );
  }
}
