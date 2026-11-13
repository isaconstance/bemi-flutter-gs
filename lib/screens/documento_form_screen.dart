import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/documento.dart';
import '../providers/documento_provider.dart';

class DocumentoFormScreen extends StatefulWidget {
  final Documento? documento;

  const DocumentoFormScreen({
    super.key,
    this.documento,
  });

  @override
  State<DocumentoFormScreen> createState() =>
      _DocumentoFormScreenState();
}

class _DocumentoFormScreenState extends State<DocumentoFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final _tipoController = TextEditingController();
  final _validadeController = TextEditingController();
  final _observacaoController = TextEditingController();

  String _status = 'OK';
  bool _salvando = false;

  bool get _editando => widget.documento != null;

  @override
  void initState() {
    super.initState();

    final documento = widget.documento;

    if (documento != null) {
      _tipoController.text = documento.tipo;
      _validadeController.text = documento.validade ?? '';
      _observacaoController.text = documento.observacao;
      _status = documento.status;
    }
  }

  @override
  void dispose() {
    _tipoController.dispose();
    _validadeController.dispose();
    _observacaoController.dispose();
    super.dispose();
  }

  Future<void> _selecionarData() async {
    final dataAtual = DateTime.now();

    DateTime? dataInicial;

    if (_validadeController.text.isNotEmpty) {
      dataInicial = DateTime.tryParse(_validadeController.text);
    }

    final dataSelecionada = await showDatePicker(
      context: context,
      initialDate: dataInicial ?? dataAtual,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      helpText: 'Selecione a validade',
    );

    if (dataSelecionada != null) {
      setState(() {
        _validadeController.text =
            '${dataSelecionada.year}-'
            '${dataSelecionada.month.toString().padLeft(2, '0')}-'
            '${dataSelecionada.day.toString().padLeft(2, '0')}';
      });
    }
  }

  Future<void> _salvarDocumento() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _salvando = true;
    });

    final provider = context.read<DocumentoProvider>();

    try {
      final tipo = _tipoController.text.trim();
      final validade = _validadeController.text.trim();
      final observacao = _observacaoController.text.trim();

      if (_editando) {
        final documentoAtualizado = Documento(
          id: widget.documento!.id,
          tipo: tipo,
          validade: validade.isEmpty ? null : validade,
          status: _status,
          observacao: observacao,
        );

        await provider.editarDocumento(documentoAtualizado);
      } else {
        await provider.cadastrarDocumento(
          tipo: tipo,
          validade: validade.isEmpty ? null : validade,
          status: _status,
          observacao: observacao,
        );
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _editando
                ? 'Documento atualizado com sucesso!'
                : 'Documento cadastrado com sucesso!',
          ),
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao salvar documento: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _salvando = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _editando ? 'Editar documento' : 'Novo documento',
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _editando
                    ? 'Atualize as informações do documento.'
                    : 'Cadastre um novo documento.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),

              const SizedBox(height: 24),

              TextFormField(
                controller: _tipoController,
                decoration: const InputDecoration(
                  labelText: 'Tipo do documento',
                  hintText: 'Ex.: RG, Cartão SUS',
                  prefixIcon: Icon(Icons.description_outlined),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Informe o tipo do documento';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 18),

              TextFormField(
                controller: _validadeController,
                readOnly: true,
                onTap: _selecionarData,
                decoration: InputDecoration(
                  labelText: 'Data de validade',
                  hintText: 'Opcional',
                  prefixIcon: const Icon(Icons.calendar_today),
                  suffixIcon: IconButton(
                    onPressed: _selecionarData,
                    icon: const Icon(Icons.date_range),
                  ),
                  border: const OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 18),

              DropdownButtonFormField<String>(
                value: _status,
                decoration: const InputDecoration(
                  labelText: 'Status',
                  prefixIcon: Icon(Icons.check_circle_outline),
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'OK',
                    child: Text('OK'),
                  ),
                  DropdownMenuItem(
                    value: 'Pendente',
                    child: Text('Pendente'),
                  ),
                  DropdownMenuItem(
                    value: 'Vencido',
                    child: Text('Vencido'),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _status = value;
                    });
                  }
                },
              ),

              const SizedBox(height: 18),

              TextFormField(
                controller: _observacaoController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Observação',
                  hintText: 'Adicione informações sobre o documento',
                  alignLabelWithHint: true,
                  prefixIcon: Icon(Icons.notes),
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 28),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _salvando ? null : _salvarDocumento,
                  child: _salvando
                      ? const CircularProgressIndicator()
                      : Text(
                          _editando
                              ? 'Salvar alterações'
                              : 'Cadastrar documento',
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
