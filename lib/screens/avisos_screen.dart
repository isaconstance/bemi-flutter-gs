import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/consulta.dart';
import '../providers/consulta_provider.dart';
import '../theme/app_theme.dart';

class AvisosScreen extends StatefulWidget {
  const AvisosScreen({super.key});

  @override
  State<AvisosScreen> createState() => _AvisosScreenState();
}

class _AvisosScreenState extends State<AvisosScreen> {
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
      backgroundColor: AppColors.fundo,
      appBar: AppBar(
        backgroundColor: AppColors.fundo,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back,
            color: AppColors.verde,
            size: 30,
          ),
        ),
        title: const Text(
          'Meus avisos',
          style: TextStyle(
            color: AppColors.verde,
            fontSize: 27,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: RefreshIndicator(
        color: AppColors.verde,
        onRefresh: provider.carregarConsultas,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
          children: [
            const Text(
              'Fique por dentro de informações importantes.',
              style: TextStyle(
                color: AppColors.textoSecundario,
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
                  child: CircularProgressIndicator(
                    color: AppColors.verde,
                  ),
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
        color: AppColors.verdeClaro,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.notifications_active_outlined,
            color: AppColors.verde,
            size: 42,
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  quantidade == 1
                      ? '1 consulta cadastrada'
                      : '$quantidade consultas cadastradas',
                  style: const TextStyle(
                    color: AppColors.verde,
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Confira os lembretes abaixo.',
                  style: TextStyle(
                    color: AppColors.textoEscuro,
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
        color: AppColors.verdeClaro,
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
          iconColor: AppColors.verde,
          collapsedIconColor: AppColors.verde,
          leading: const Icon(
            Icons.calendar_month_outlined,
            color: AppColors.verde,
            size: 34,
          ),
          title: const Text(
            'Consulta cadastrada',
            style: TextStyle(
              color: AppColors.textoEscuro,
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              'Você tem consulta de ${consulta.especialidade} em ${_formatarData(consulta.data)}.',
              style: const TextStyle(
                color: AppColors.textoEscuro,
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
              color: AppColors.verde,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          Expanded(
            child: Text(
              valor.isEmpty ? 'Não informado' : valor,
              style: const TextStyle(
                color: AppColors.textoEscuro,
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
        color: AppColors.vermelhoEmergencia.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(25),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.shield_outlined,
                color: AppColors.vermelhoEmergencia,
                size: 34,
              ),
              SizedBox(width: 14),
              Expanded(
                child: Text(
                  'Cuidado com golpes!',
                  style: TextStyle(
                    color: AppColors.textoEscuro,
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
              color: AppColors.textoEscuro,
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
        color: AppColors.verdeClaro,
        borderRadius: BorderRadius.circular(24),
      ),
      child: const Column(
        children: [
          Icon(
            Icons.event_available_outlined,
            color: AppColors.verde,
            size: 45,
          ),
          SizedBox(height: 12),
          Text(
            'Nenhuma consulta cadastrada no momento.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.verde,
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
        color: AppColors.verdeClaro,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.cloud_off_outlined,
            color: AppColors.verde,
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
              backgroundColor: AppColors.verde,
              foregroundColor: AppColors.branco,
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
