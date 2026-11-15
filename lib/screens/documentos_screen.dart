import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/documento.dart';
import '../providers/documento_provider.dart';
import '../theme/app_theme.dart';
import 'documento_form_screen.dart';

class DocumentosScreen extends StatefulWidget {
  const DocumentosScreen({super.key});

  @override
  State<DocumentosScreen> createState() => _DocumentosScreenState();
}

class _DocumentosScreenState extends State<DocumentosScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DocumentoProvider>().carregarDocumentos();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DocumentoProvider>();

    return Scaffold(
      backgroundColor: AppColors.fundoDocumentos,
      appBar: AppBar(
        backgroundColor: AppColors.fundoDocumentos,
        foregroundColor: AppColors.verde,
        elevation: 0,
        title: const Text(
          'Meus documentos',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: _conteudo(provider),
    );
  }

  Widget _conteudo(DocumentoProvider provider) {
    if (provider.carregando && provider.documentos.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.verde),
      );
    }

    if (provider.erro != null && provider.documentos.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline,
                size: 48,
                color: AppColors.verde,
              ),
              const SizedBox(height: 12),
              const Text(
                'Não foi possível carregar seus documentos.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: provider.carregarDocumentos,
                child: const Text('Tentar novamente'),
              ),
            ],
          ),
        ),
      );
    }

    final documentos = provider.documentos;
    final regulares = documentos
        .where((doc) => doc.status.toLowerCase() == 'ok')
        .length;

    return RefreshIndicator(
      color: AppColors.verde,
      onRefresh: provider.carregarDocumentos,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
        children: [
          const Text(
            'Tenha seus documentos sempre organizados.',
            style: TextStyle(
              fontSize: 17,
              color: AppColors.pretoSecundario,
            ),
          ),
          const SizedBox(height: 22),

          _resumo(documentos.length, regulares),
          const SizedBox(height: 22),

          OutlinedButton.icon(
            onPressed: _adicionarDocumento,
            icon: const Icon(Icons.add, size: 24),
            label: const Text(
              'Adicionar documento',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.verde,
              side: const BorderSide(
                color: AppColors.verde,
                width: 1.5,
              ),
              minimumSize: const Size(double.infinity, 58),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
          ),

          const SizedBox(height: 28),

          const Text(
            'Seus documentos',
            style: TextStyle(
              color: AppColors.verde,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 14),

          if (documentos.isEmpty)
            _vazio()
          else
            ...documentos.map(_cardDocumento),
        ],
      ),
    );
  }

  Widget _resumo(int total, int regulares) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.verdeClaro,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.description_outlined,
            color: AppColors.verde,
            size: 42,
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$total ${total == 1 ? 'documento cadastrado' : 'documentos cadastrados'}',
                  style: const TextStyle(
                    color: AppColors.verde,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  total == regulares
                      ? 'Todos estão em situação regular.'
                      : '$regulares de $total em situação regular.',
                  style: const TextStyle(fontSize: 15),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _cardDocumento(Documento documento) {
    final cor = _corStatus(documento.status);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.branco,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.07),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.description_outlined,
                color: AppColors.verde,
                size: 34,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  documento.tipo,
                  style: const TextStyle(
                    color: AppColors.verde,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              _menuDocumento(documento),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              const Icon(
                Icons.calendar_today_outlined,
                size: 17,
                color: AppColors.pretoSuave,
              ),
              const SizedBox(width: 7),
              Expanded(
                child: Text(
                  documento.validade == null ||
                          documento.validade!.isEmpty
                      ? 'Sem validade definida'
                      : 'Validade: ${_formatarData(documento.validade!)}',
                  style: const TextStyle(fontSize: 15),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 11,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: cor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  documento.status,
                  style: TextStyle(
                    color: cor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          if (documento.observacao.trim().isNotEmpty) ...[
            const SizedBox(height: 14),
            Text(
              documento.observacao,
              style: const TextStyle(
                fontSize: 15,
                color: AppColors.pretoSecundario,
              ),
            ),
          ],

          const SizedBox(height: 18),

          SizedBox(
            width: double.infinity,
            height: 52,
            child: OutlinedButton.icon(
              onPressed: () => _verDocumento(documento),
              icon: const Icon(Icons.description_outlined),
              label: const Text(
                'Ver documento',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.verde,
                side: const BorderSide(
                  color: AppColors.verde,
                  width: 1.3,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _menuDocumento(Documento documento) {
    return PopupMenuButton<String>(
      icon: const Icon(
        Icons.more_vert,
        color: AppColors.verde,
      ),
      onSelected: (opcao) {
        if (opcao == 'editar') {
          _editarDocumento(documento);
        } else if (opcao == 'excluir') {
          _confirmarExclusao(documento);
        }
      },
      itemBuilder: (_) => const [
        PopupMenuItem(
          value: 'editar',
          child: Text('Editar'),
        ),
        PopupMenuItem(
          value: 'excluir',
          child: Text('Excluir'),
        ),
      ],
    );
  }

  Widget _vazio() {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: AppColors.verdeClaro,
        borderRadius: BorderRadius.circular(22),
      ),
      child: const Column(
        children: [
          Icon(
            Icons.folder_open,
            color: AppColors.verde,
            size: 48,
          ),
          SizedBox(height: 12),
          Text(
            'Você ainda não cadastrou documentos.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: AppColors.verde,
            ),
          ),
        ],
      ),
    );
  }

  Color _corStatus(String status) {
    switch (status.toLowerCase()) {
      case 'ok':
        return AppColors.verdeStatus;
      case 'pendente':
        return AppColors.douradoStatus;
      case 'vencido':
        return AppColors.vermelhoStatus;
      default:
        return AppColors.verde;
    }
  }

  String _formatarData(String data) {
    final partes = data.split('-');

    if (partes.length == 3) {
      return '${partes[2]}/${partes[1]}/${partes[0]}';
    }

    return data;
  }

  String? _imagemDocumento(String tipo) {
    final nome = tipo.toLowerCase();

    if (nome.contains('rg') || nome.contains('identidade')) {
      return 'assets/images/documento_rg.jpeg';
    }

    if (nome.contains('sus')) {
      return 'assets/images/cartao_sus.jpeg';
    }

    if (nome.contains('resid')) {
      return 'assets/images/residencia.jpeg';
    }

    return null;
  }

  void _verDocumento(Documento documento) {
    final imagem = _imagemDocumento(documento.tipo);

    showDialog<void>(
      context: context,
      builder: (dialogContext) => Dialog(
        backgroundColor: AppColors.branco,
        insetPadding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 32,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  documento.tipo,
                  style: const TextStyle(
                    color: AppColors.textoTitulo,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 22),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: imagem != null
                      ? Image.asset(
                          imagem,
                          width: double.infinity,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) =>
                              _imagemIndisponivel(),
                        )
                      : _imagemIndisponivel(),
                ),
                const SizedBox(height: 14),
                const Text(
                  'Imagem ilustrativa para demonstração.',
                  style: TextStyle(
                    color: AppColors.textoSecundario,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 24),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Navigator.pop(dialogContext),
                    child: const Text(
                      'Fechar',
                      style: TextStyle(
                        color: AppColors.verde,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _imagemIndisponivel() {
    return Container(
      width: double.infinity,
      height: 190,
      color: AppColors.verdeClaro,
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.description_outlined,
            color: AppColors.verde,
            size: 65,
          ),
          SizedBox(height: 8),
          Text('Imagem ilustrativa indisponível'),
        ],
      ),
    );
  }

  Future<void> _adicionarDocumento() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const DocumentoFormScreen(),
      ),
    );
  }

  Future<void> _editarDocumento(Documento documento) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DocumentoFormScreen(documento: documento),
      ),
    );
  }

  Future<void> _confirmarExclusao(Documento documento) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Excluir documento'),
        content: Text(
          'Deseja realmente excluir ${documento.tipo}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text(
              'Excluir',
              style: TextStyle(color: AppColors.vermelhoStatus),
            ),
          ),
        ],
      ),
    );

    if (confirmar == true && mounted) {
      try {
        await context
            .read<DocumentoProvider>()
            .excluirDocumento(documento.id);

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Documento excluído com sucesso!'),
          ),
        );
      } catch (e) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao excluir documento: $e'),
            backgroundColor: AppColors.vermelhoStatus,
          ),
        );
      }
    }
  }
}
