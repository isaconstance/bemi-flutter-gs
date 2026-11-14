class Consulta {
  final int id;
  final String especialidade;
  final String medico;
  final String local;
  final EnderecoConsulta endereco;
  final String data;
  final String hora;
  final String observacao;
  final String status;

  Consulta({
    required this.id,
    required this.especialidade,
    required this.medico,
    required this.local,
    required this.endereco,
    required this.data,
    required this.hora,
    required this.observacao,
    required this.status,
  });

  factory Consulta.fromJson(Map<String, dynamic> json) {
    return Consulta(
      id: json['id'],
      especialidade: json['especialidade'] ?? '',
      medico: json['medico'] ?? '',
      local: json['local'] ?? '',
      endereco: EnderecoConsulta.fromJson(
        json['endereco'] ?? {},
      ),
      data: json['data'] ?? '',
      hora: json['hora'] ?? '',
      observacao: json['observacao'] ?? '',
      status: json['status'] ?? '',
    );
  }
}

class EnderecoConsulta {
  final String logradouro;
  final String numero;
  final String bairro;
  final String cidade;
  final String cep;

  EnderecoConsulta({
    required this.logradouro,
    required this.numero,
    required this.bairro,
    required this.cidade,
    required this.cep,
  });

  factory EnderecoConsulta.fromJson(Map<String, dynamic> json) {
    return EnderecoConsulta(
      logradouro: json['logradouro'] ?? '',
      numero: json['numero'] ?? '',
      bairro: json['bairro'] ?? '',
      cidade: json['cidade'] ?? '',
      cep: json['cep'] ?? '',
    );
  }

  String get enderecoCompleto {
    return '$logradouro, $numero - $bairro, $cidade - CEP: $cep';
  }
}
