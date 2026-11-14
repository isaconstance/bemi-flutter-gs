import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/consulta.dart';
import '../providers/consulta_provider.dart';
import '../widgets/app_bottom_navigation.dart';
import 'home_screen.dart';
import 'documentos_screen.dart';

class ConsultasScreen extends StatefulWidget {
  const ConsultasScreen({super.key});

  @override
  State<ConsultasScreen> createState() => _ConsultasScreenState();
}

class _ConsultasScreenState extends State<ConsultasScreen> {
  static const Color verde = Color(0xFF174F3B);
  static const Color fundo = Color(0xFFF7F8F3);
  static const Color verdeClaro = Color(0xFFE8ECD9);
  static const Color dourado = Color(0xFFF2C879);


  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<ConsultaProvider>().carregarConsultas();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ConsultaProvider>();

    return Scaffold(
      backgroundColor: fundo,
      appBar: AppBar(
        backgroundColor: fundo,
        elevation: 0,
        centerTitle: false,
        title: const Text(
          'Minhas consultas',
          style: TextStyle(
            color: verde,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),
      body: _construirConteudo(provider),
    );
  }

  Widget _construirConteudo(ConsultaProvider provider) {
    if (provider.carregando && provider.consultas.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(color: verde),
      );
    }

    if (provider.erro != null && provider.consultas.isEmpty) {
      return _estadoErro(provider);
    }

    if (provider.consultas.isEmpty) {
      return RefreshIndicator(
        color: verde,
        onRefresh: provider.carregarConsultas,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: const [
            SizedBox(height: 130),
            Icon(
              Icons.calendar_month_outlined,
              size: 65,
              color: verde,
            ),
            SizedBox(height: 16),
            Center(
              child: Text(
                'Nenhuma consulta encontrada.',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      color: verde,
      onRefresh: provider.carregarConsultas,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          const Text(
            'Acompanhe seus agendamentos e confira as informações '
            'das suas próximas consultas.',
            style: TextStyle(
              color: Colors.black54,
              fontSize: 14,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),

          ...provider.consultas.map(
            (consulta) => _cardConsulta(consulta),
          ),
        ],
      ),
    );
  }

  Widget _estadoErro(ConsultaProvider provider) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.cloud_off_outlined,
              color: verde,
              size: 55,
            ),
            const SizedBox(height: 16),
            const Text(
              'Não foi possível carregar suas consultas.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: provider.carregarConsultas,
              style: ElevatedButton.styleFrom(
                backgroundColor: verde,
                foregroundColor: Colors.white,
              ),
              child: const Text('Tentar novamente'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _cardConsulta(Consulta consulta) {
    final confirmada =
        consulta.status.toLowerCase() == 'confirmada';

    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black.withOpacity(0.04)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  consulta.especialidade,
                  style: const TextStyle(
                    color: verde,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              _statusChip(consulta.status, confirmada),
            ],
          ),

          const SizedBox(height: 18),

          _informacao(
            Icons.person_outline,
            'Médico(a)',
            consulta.medico,
          ),

          const SizedBox(height: 15),

          Row(
            children: [
              Expanded(
                child: _informacao(
                  Icons.calendar_today_outlined,
                  'Data',
                  _formatarData(consulta.data),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _informacao(
                  Icons.access_time,
                  'Horário',
                  consulta.hora,
                ),
              ),
            ],
          ),

          const SizedBox(height: 15),

          _informacao(
            Icons.local_hospital_outlined,
            'Local da consulta',
            consulta.local,
          ),

          const SizedBox(height: 15),

          _informacao(
            Icons.location_on_outlined,
            'Endereço',
            consulta.endereco.enderecoCompleto,
          ),

          const SizedBox(height: 18),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(13),
            decoration: BoxDecoration(
              color: verdeClaro.withOpacity(0.75),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.notifications_none,
                  color: verde,
                  size: 21,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Lembrete',
                        style: TextStyle(
                          color: verde,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        consulta.observacao.isEmpty
                            ? 'Nenhuma observação cadastrada.'
                            : consulta.observacao,
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 13,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusChip(String status, bool confirmada) {
    final cor = confirmada
        ? verde
        : status.toLowerCase() == 'pendente'
            ? const Color(0xFF9A6A16)
            : Colors.grey.shade700;

    final fundoChip = confirmada
        ? verdeClaro
        : status.toLowerCase() == 'pendente'
            ? const Color(0xFFFFF1D6)
            : Colors.grey.shade200;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 11,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: fundoChip,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: cor,
          fontWeight: FontWeight.w600,
          fontSize: 11,
        ),
      ),
    );
  }

  Widget _informacao(
    IconData icone,
    String titulo,
    String valor,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icone,
          color: verde,
          size: 20,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                titulo,
                style: const TextStyle(
                  color: Colors.black54,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                valor.isEmpty ? 'Não informado' : valor,
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatarData(String data) {
    try {
      final partes = data.split('-');

      if (partes.length != 3) return data;

      return '${partes[2]}/${partes[1]}/${partes[0]}';
    } catch (_) {
      return data;
    }
  }
}
