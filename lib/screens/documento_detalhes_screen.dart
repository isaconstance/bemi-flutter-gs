import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/documento.dart';
import '../providers/documento_provider.dart';
import '../theme/app_theme.dart';
import 'documento_form_screen.dart';

class DocumentoDetalhesScreen extends StatefulWidget {
  final Documento documento;

  const DocumentoDetalhesScreen({
    super.key,
    required this.documento,
  });

  @override
  State<DocumentoDetalhesScreen> createState() =>
      _DocumentoDetalhesScreenState();
}

class _DocumentoDetalhesScreenState
    extends State<DocumentoDetalhesScreen> {
  Future<void> _editarDocumento(Documento documento) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DocumentoFormScreen(
          documento: documento,
        ),
      ),
    );
  }

  Future<void> _excluirDocumento(Documento documento) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir documento'),
        content: Text(
          'Deseja realmente excluir ${documento.tipo}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Excluir',
              style: TextStyle(color: AppColors.vermelho),
            ),
          ),
        ],
      ),
    );

    if (confirmar != true || !mounted) return;

    try {
      await context
          .read<DocumentoProvider>()
          .excluirDocumento(documento.id);

      if (!mounted) return;

      Navigator.pop(context);

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
          backgroundColor: AppColors.vermelho,
        ),
      );
    }
  }

  Widget _informacao(String titulo, String valor, IconData icone) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.branco,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icone,
            color: AppColors.verde,
            size: 25,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: const TextStyle(
                    color: AppColors.cinza,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  valor,
                  style: const TextStyle(
                    color: AppColors.verde,
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DocumentoProvider>();

    final documento = provider.documentos.firstWhere(
      (item) => item.id == widget.documento.id,
      orElse: () => widget.documento,
    );

    return Scaffold(
      backgroundColor: AppColors.fundo,
      appBar: AppBar(
        title: const Text('Detalhes do documento'),
        backgroundColor: AppColors.verde,
        foregroundColor: AppColors.branco,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: AppColors.verdeClaro,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Icon(
                  Icons.description_outlined,
                  color: AppColors.verde,
                  size: 65,
                ),
              ),
            ),

            const SizedBox(height: 22),

            Center(
              child: Text(
                documento.tipo,
                style: const TextStyle(
                  color: AppColors.verde,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 28),

            const Text(
              'Informações do documento',
              style: TextStyle(
                color: AppColors.verde,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16),

            _informacao(
              'Identificação',
              documento.id.toString(),
              Icons.tag,
            ),

            _informacao(
              'Tipo de documento',
              documento.tipo,
              Icons.description_outlined,
            ),

            _informacao(
              'Validade',
              documento.validade?.isNotEmpty == true
                  ? documento.validade!
                  : 'Não informada',
              Icons.calendar_today_outlined,
            ),

            _informacao(
              'Status',
              documento.status,
              Icons.check_circle_outline,
            ),

            _informacao(
              'Observações',
              documento.observacao.isNotEmpty
                  ? documento.observacao
                  : 'Nenhuma observação',
              Icons.notes,
            ),

            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton.icon(
                onPressed: () => _editarDocumento(documento),
                icon: const Icon(Icons.edit_outlined),
                label: const Text(
                  'Editar documento',
                  style: TextStyle(fontSize: 17),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.verde,
                  foregroundColor: AppColors.branco,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              height: 54,
              child: OutlinedButton.icon(
                onPressed: () => _excluirDocumento(documento),
                icon: const Icon(Icons.delete_outline),
                label: const Text(
                  'Excluir documento',
                  style: TextStyle(fontSize: 17),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.vermelho,
                  side: const BorderSide(
                    color: AppColors.vermelho,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
