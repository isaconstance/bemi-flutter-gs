import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/consulta.dart';
import '../providers/consulta_provider.dart';

class AvisosScreen extends StatefulWidget {
  const AvisosScreen({super.key});

  @override
  State<AvisosScreen> createState() => _AvisosScreenState();
}

class _AvisosScreenState extends State<AvisosScreen> {
  static const Color verde = Color(0xFF174F3B);
  static const Color fundo = Color(0xFFFFF5E9);
  static const Color verdeClaro = Color(0xFFE8ECD9);
  static const Color vermelho = Color(0xFFCF332D);
  static const Color vermelhoClaro = Color(0xFFFBE5E2);
  static const Color texto = Color(0xFF292F29);
  static const Color textoSecundario = Color(0xFF6B716A);

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
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: verde, size: 30),
        ),
        title: const Text(
          'Meus avisos',
          style: TextStyle(
            color: verde,
            fontSize: 27,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: RefreshIndicator(
        color: verde,
        onRefresh: provider.carregarConsultas,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
          children: [
            const Text(
              'Fique por dentro de informações importantes.',
              style: TextStyle(
                color: textoSecundario,
                fontSize: 17,
              ),
            ),

            const SizedBox(height: 28),

            _resumoAvisos(provider.consultas.length),

            const SizedBox(height: 28),

            if (provider.carregando && provider.consultas.isEmpty)
              const Padding(
                padding: EdgeInsets.all(40),
                child: Center(
                  child: CircularProgressIndicator(color: verde),
                ),
              )
            else if (provider.erro != null && provider.consultas.isEmpty)
              _estadoErro(provider)
            else if (provider.consultas.isEmpty)
              _estadoVazio()
            else ...[
              ...provider.consultas.map(
                (consulta) => _cardConsulta(consulta),
              ),
            ],

            const SizedBox(height: 8),

            _avisoSeguranca(),
          ],
        ),
      ),
    );
  }

  Widget _resumoAvisos(int quantidade) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: verdeClaro,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.notifications_active_outlined,
            color: verde,
            size: 42,
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  quantidade == 1
                      ? '1 aviso de consulta'
                      : '$quantidade avisos de consultas',
                  style: const TextStyle(
                    color: verde,
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Confira os lembretes abaixo.',
                  style: TextStyle(
                    color: texto,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _cardConsulta(Consulta consulta) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: verdeClaro,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
        ),
        child: ExpansionTile(
          initiallyExpanded: false,
          tilePadding: const EdgeInsets.symmetric(
            horizontal: 22,
            vertical: 12,
          ),
          childrenPadding: const EdgeInsets.fromLTRB(22, 0, 22, 22),
          iconColor: verde,
          collapsedIconColor: verde,
          leading: const Icon(
            Icons.calendar_month_outlined,
            color: verde,
            size: 34,
          ),
          title: const Text(
            'Consulta próxima',
            style: TextStyle(
              color: texto,
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              'Você tem consulta de ${consulta.especialidade} em ${_formatarData(consulta.data)}.',
              style: const TextStyle(
                color: texto,
                fontSize: 16,
                height: 1.5,
              ),
            ),
          ),
          children: [
            _detalhe('Médico(a)', consulta.medico),
            _detalhe('Horário', consulta.hora),
            _detalhe('Local', consulta.local),
            _detalhe(
              'Endereço',
              consulta.endereco.enderecoCompleto,
            ),
            _detalhe(
              'Orientação',
              consulta.observacao.isEmpty
                  ? 'Nenhuma orientação cadastrada.'
                  : consulta.observacao,
            ),
          ],
        ),
      ),
    );
  }

  Widget _detalhe(String titulo, String valor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$titulo: ',
            style: const TextStyle(
              color: verde,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          Expanded(
            child: Text(
              valor.isEmpty ? 'Não informado' : valor,
              style: const TextStyle(
                color: texto,
                fontSize: 15,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _avisoSeguranca() {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: vermelhoClaro,
        borderRadius: BorderRadius.circular(25),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.shield_outlined,
                color: vermelho,
                size: 34,
              ),
              SizedBox(width: 14),
              Expanded(
                child: Text(
                  'Cuidado com golpes!',
                  style: TextStyle(
                    color: texto,
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 18),
          Text(
            'Nunca compartilhe senhas ou códigos recebidos por mensagem. '
            'Desconfie de contatos que solicitam pagamentos ou dados pessoais '
            'em nome de instituições de saúde.',
            style: TextStyle(
              color: texto,
              fontSize: 16,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _estadoVazio() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: verdeClaro,
        borderRadius: BorderRadius.circular(24),
      ),
      child: const Column(
        children: [
          Icon(
            Icons.event_available_outlined,
            color: verde,
            size: 45,
          ),
          SizedBox(height: 12),
          Text(
            'Nenhum aviso de consulta no momento.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: verde,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _estadoErro(ConsultaProvider provider) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: verdeClaro,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.cloud_off_outlined,
            color: verde,
            size: 42,
          ),
          const SizedBox(height: 12),
          const Text(
            'Não foi possível carregar os avisos.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 14),
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
    );
  }

  String _formatarData(String data) {
    final partes = data.split('-');

    if (partes.length != 3) return data;

    return '${partes[2]}/${partes[1]}/${partes[0]}';
  }
}