
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/documento_provider.dart';
import '../models/documento.dart';
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
      appBar: AppBar(
        title: const Text('Meus documentos'),
        centerTitle: true,
      ),
      body: _construirConteudo(provider),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const DocumentoFormScreen(),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Adicionar documento'),
      ),
    );
  }

  Widget _construirConteudo(DocumentoProvider provider) {
    if (provider.carregando && provider.documentos.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
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
                color: Colors.red,
              ),
              const SizedBox(height: 12),
              const Text(
                'Não foi possível carregar os documentos.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: provider.carregarDocumentos,
                child: const Text('Tentar novamente'),
              ),
            ],
          ),
        ),
      );
    }

    if (provider.documentos.isEmpty) {
      return RefreshIndicator(
        onRefresh: provider.carregarDocumentos,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: const [
            SizedBox(height: 150),
            Icon(
              Icons.folder_open,
              size: 60,
              color: Colors.grey,
            ),
            SizedBox(height: 12),
            Center(
              child: Text('Nenhum documento cadastrado.'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: provider.carregarDocumentos,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: provider.documentos.length,
        itemBuilder: (context, index) {
          final documento = provider.documentos[index];

          return _cardDocumento(documento);
        },
      ),
    );
  }

  Widget _cardDocumento(Documento documento) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: const CircleAvatar(
          child: Icon(Icons.description_outlined),
        ),
        title: Text(
          documento.tipo,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 6),
            Text(
              documento.validade == null
                  ? 'Sem validade definida'
                  : 'Validade: ${documento.validade}',
            ),
            Text('Status: ${documento.status}'),
            Text(documento.observacao),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'editar') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DocumentoFormScreen(
                    documento: documento,
                  ),
                ),
              );
            }

            if (value == 'excluir') {
              _confirmarExclusao(documento);
            }
          },
          itemBuilder: (context) => const [
            PopupMenuItem(
              value: 'editar',
              child: Text('Editar'),
            ),
            PopupMenuItem(
              value: 'excluir',
              child: Text('Excluir'),
            ),
          ],
        ),
        isThreeLine: true,
      ),
    );
  }

  Future<void> _confirmarExclusao(Documento documento) async {
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
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirmar == true) {
      try {
        await context.read<DocumentoProvider>().excluirDocumento(
          documento.id,
        );

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
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
