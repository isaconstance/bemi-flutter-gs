import 'package:flutter_test/flutter_test.dart';
import 'package:bemi/models/documento.dart';
import 'package:bemi/models/consulta.dart';
import 'package:bemi/providers/documento_provider.dart';
import 'package:bemi/providers/consulta_provider.dart';

void main() {
  group('Testes do modelo Documento', () {
    test('Deve criar um documento corretamente', () {
      final documento = Documento(
        id: 1,
        tipo: 'RG',
        validade: '2030-10-20',
        status: 'OK',
        observacao: 'Documento atualizado',
      );

      expect(documento.id, 1);
      expect(documento.tipo, 'RG');
      expect(documento.validade, '2030-10-20');
      expect(documento.status, 'OK');
      expect(documento.observacao, 'Documento atualizado');
    });

    test('Deve converter um documento para JSON', () {
      final documento = Documento(
        id: 2,
        tipo: 'Cartão SUS',
        validade: null,
        status: 'OK',
        observacao: '',
      );

      final json = documento.toJson();

      expect(json['id'], 2);
      expect(json['tipo'], 'Cartão SUS');
      expect(json['validade'], null);
      expect(json['status'], 'OK');
      expect(json['observacao'], '');
    });

    test('Deve criar um documento a partir de JSON', () {
      final documento = Documento.fromJson({
        'id': 3,
        'tipo': 'Comprovante de residência',
        'validade': null,
        'status': 'Pendente',
        'observacao': 'Atualizar comprovante',
      });

      expect(documento.id, 3);
      expect(documento.tipo, 'Comprovante de residência');
      expect(documento.status, 'Pendente');
      expect(documento.observacao, 'Atualizar comprovante');
    });
  });

  group('Testes do modelo Consulta', () {
    test('Deve criar uma consulta corretamente', () {
      final consulta = Consulta(
        id: 1,
        especialidade: 'Cardiologia',
        medico: 'Dr. João',
        local: 'UBS Central',
        endereco: EnderecoConsulta(
          logradouro: 'Rua das Flores',
          numero: '100',
          bairro: 'Centro',
          cidade: 'Guarulhos',
          cep: '07000-000',
        ),
        data: '2026-12-10',
        hora: '14:00',
        observacao: 'Levar exames',
        status: 'Agendada',
      );

      expect(consulta.id, 1);
      expect(consulta.especialidade, 'Cardiologia');
      expect(consulta.medico, 'Dr. João');
      expect(consulta.local, 'UBS Central');
      expect(consulta.data, '2026-12-10');
      expect(consulta.hora, '14:00');
      expect(consulta.observacao, 'Levar exames');
      expect(consulta.status, 'Agendada');
    });

    test('Deve montar o endereço completo corretamente', () {
      final endereco = EnderecoConsulta(
        logradouro: 'Rua das Flores',
        numero: '100',
        bairro: 'Centro',
        cidade: 'Guarulhos',
        cep: '07000-000',
      );

      expect(
        endereco.enderecoCompleto,
        'Rua das Flores, 100 - Centro, Guarulhos - CEP: 07000-000',
      );
    });

    test('Deve criar uma consulta a partir de JSON', () {
      final consulta = Consulta.fromJson({
        'id': 2,
        'especialidade': 'Clínico Geral',
        'medico': 'Dra. Maria',
        'local': 'UBS Jardim',
        'endereco': {
          'logradouro': 'Avenida Brasil',
          'numero': '200',
          'bairro': 'Jardim',
          'cidade': 'Guarulhos',
          'cep': '07100-000',
        },
        'data': '2026-12-15',
        'hora': '09:30',
        'observacao': 'Retorno',
        'status': 'Agendada',
      });

      expect(consulta.id, 2);
      expect(consulta.especialidade, 'Clínico Geral');
      expect(consulta.medico, 'Dra. Maria');
      expect(consulta.endereco.cidade, 'Guarulhos');
      expect(consulta.hora, '09:30');
      expect(consulta.observacao, 'Retorno');
    });
  });

  group('Testes do DocumentoProvider', () {
    test('Deve iniciar com a lista de documentos vazia', () {
      final provider = DocumentoProvider();

      expect(provider.documentos, isEmpty);
      expect(provider.carregando, isFalse);
      expect(provider.erro, isNull);
    });
  });

  group('Testes do ConsultaProvider', () {
    test('Deve iniciar com a lista de consultas vazia', () {
      final provider = ConsultaProvider();

      expect(provider.consultas, isEmpty);
      expect(provider.carregando, isFalse);
      expect(provider.erro, isNull);
    });
  });

  group('Testes adicionais', () {
    test('Documento deve aceitar campos opcionais vazios', () {
      final documento = Documento.fromJson({'id': 4});

      expect(documento.id, 4);
      expect(documento.tipo, '');
      expect(documento.validade, isNull);
      expect(documento.status, '');
      expect(documento.observacao, '');
    });

    test('Endereço deve ser criado corretamente a partir de JSON', () {
      final endereco = EnderecoConsulta.fromJson({
        'logradouro': 'Rua A',
        'numero': '50',
        'bairro': 'Centro',
        'cidade': 'Guarulhos',
        'cep': '07000-000',
      });

      expect(endereco.logradouro, 'Rua A');
      expect(endereco.numero, '50');
      expect(endereco.bairro, 'Centro');
      expect(endereco.cidade, 'Guarulhos');
      expect(endereco.cep, '07000-000');
    });
  });
}
