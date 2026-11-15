import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/documento.dart';
import '../providers/documento_provider.dart';
import '../theme/app_theme.dart';

class DocumentoFormScreen extends StatefulWidget {
  final Documento? documento;

  const DocumentoFormScreen({
    super.key,
    this.documento,
  });

  @override
  State<DocumentoFormScreen> createState() => _DocumentoFormScreenState();
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

  InputDecoration _decoracao({
    required String label,
    required IconData icone,
    String? hint,
    Widget? sufixo,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: Icon(icone, color: AppColors.verde),
      suffixIcon: sufixo,
      filled: true,
      fillColor: AppColors.branco,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 18,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFFE1E6DF)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: AppColors.verde,
          width: 1.5,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: AppColors.vermelhoStatus,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: AppColors.vermelhoStatus,
          width: 1.5,
        ),
      ),
    );
  }

  Future<void> _selecionarData() async {
    final dataAtual = DateTime.now();
    final dataInicial = DateTime.tryParse(_validadeController.text);

    final dataSelecionada = await showDatePicker(
      context: context,
      initialDate: dataInicial ?? dataAtual,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      helpText: 'Selecione a validade',
      cancelText: 'Cancelar',
      confirmText: 'Confirmar',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.verde,
              onPrimary: AppColors.branco,
              surface: AppColors.branco,
              onSurface: AppColors.verde,
            ),
          ),
          child: child!,
        );
      },
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
    if (!_formKey.currentState!.validate()) return;

    setState(() => _salvando = true);

    final provider = context.read<DocumentoProvider>();

    try {
      final tipo = _tipoController.text.trim();
      final validade = _validadeController.text.trim();
      final observacao = _observacaoController.text.trim();

      if (_editando) {
        final atualizado = Documento(
          id: widget.documento!.id,
          tipo: tipo,
          validade: validade.isEmpty ? null : validade,
          status: _status,
          observacao: observacao,
        );

        await provider.editarDocumento(atualizado);
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
          backgroundColor: AppColors.vermelhoStatus,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _salvando = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fundo,
      appBar: AppBar(
        backgroundColor: AppColors.fundo,
        foregroundColor: AppColors.verde,
        elevation: 0,
        title: Text(
          _editando ? 'Editar documento' : 'Adicionar documento',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 30),
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.verdeClaro,
                borderRadius: BorderRadius.circular(22),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.folder_shared_outlined,
                    color: AppColors.verde,
                    size: 38,
                  ),
                  SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      'Mantenha seus documentos organizados e suas informações sempre atualizadas.',
                      style: TextStyle(
                        color: AppColors.verde,
                        fontSize: 15,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
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
            const SizedBox(height: 18),
            TextFormField(
              controller: _tipoController,
              textCapitalization: TextCapitalization.words,
              decoration: _decoracao(
                label: 'Tipo do documento',
                hint: 'Ex.: RG, Cartão SUS',
                icone: Icons.description_outlined,
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Informe o tipo do documento';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _validadeController,
              readOnly: true,
              onTap: _selecionarData,
              decoration: _decoracao(
                label: 'Data de validade',
                hint: 'Opcional',
                icone: Icons.calendar_today_outlined,
                sufixo: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_validadeController.text.isNotEmpty)
                      IconButton(
                        tooltip: 'Limpar data',
                        onPressed: () {
                          setState(() {
                            _validadeController.clear();
                          });
                        },
                        icon: const Icon(
                          Icons.close,
                          color: AppColors.cinza,
                        ),
                      ),
                    IconButton(
                      tooltip: 'Selecionar data',
                      onPressed: _selecionarData,
                      icon: const Icon(
                        Icons.calendar_month_outlined,
                        color: AppColors.verde,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 26),
            const Text(
              'Situação do documento',
              style: TextStyle(
                color: AppColors.verde,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Selecione a situação atual:',
              style: TextStyle(
                color: AppColors.pretoSuave,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 9,
              runSpacing: 10,
              children: [
                _opcaoStatus('OK', AppColors.verdeStatus),
                _opcaoStatus('Pendente', AppColors.douradoStatus),
                _opcaoStatus('Vencido', AppColors.vermelhoStatus),
              ],
            ),
            const SizedBox(height: 28),
            const Text(
              'Observações',
              style: TextStyle(
                color: AppColors.verde,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _observacaoController,
              textCapitalization: TextCapitalization.sentences,
              maxLines: 4,
              decoration: _decoracao(
                label: 'Observação',
                hint: 'Adicione informações sobre o documento...',
                icone: Icons.notes_outlined,
              ).copyWith(
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              height: 56,
              child: ElevatedButton(
                onPressed: _salvando ? null : _salvarDocumento,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.verde,
                  foregroundColor: AppColors.branco,
                  disabledBackgroundColor:
                      AppColors.verde.withValues(alpha: 0.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(17),
                  ),
                  elevation: 0,
                ),
                child: _salvando
                    ? const SizedBox(
                        height: 23,
                        width: 23,
                        child: CircularProgressIndicator(
                          color: AppColors.branco,
                          strokeWidth: 2.5,
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.check_circle_outline),
                          const SizedBox(width: 10),
                          Text(
                            _editando
                                ? 'Salvar alterações'
                                : 'Cadastrar documento',
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _opcaoStatus(String texto, Color cor) {
    final selecionado = _status == texto;

    return ChoiceChip(
      label: Text(texto),
      selected: selecionado,
      onSelected: (_) {
        setState(() => _status = texto);
      },
      showCheckmark: true,
      checkmarkColor: selecionado ? AppColors.branco : cor,
      selectedColor: cor,
      backgroundColor: AppColors.branco,
      side: BorderSide(
        color: selecionado ? cor : const Color(0xFFE1E6DF),
      ),
      labelStyle: TextStyle(
        color: selecionado ? AppColors.branco : cor,
        fontWeight: FontWeight.bold,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 9,
      ),
    );
  }
}
