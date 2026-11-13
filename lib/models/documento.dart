class Documento {
  final int id;
  final String tipo;
  final String? validade;
  final String status;
  final String observacao;

  Documento({
    required this.id,
    required this.tipo,
    this.validade,
    required this.status,
    required this.observacao,
  });

  factory Documento.fromJson(Map<String, dynamic> json) {
    return Documento(
      id: json['id'],
      tipo: json['tipo'] ?? '',
      validade: json['validade'],
      status: json['status'] ?? '',
      observacao: json['observacao'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tipo': tipo,
      'validade': validade,
      'status': status,
      'observacao': observacao,
    };
  }
}
