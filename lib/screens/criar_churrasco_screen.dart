import 'package:flutter/material.dart';

import '../models/churrasco.dart';

class CriarChurrascoScreen extends StatefulWidget {
  const CriarChurrascoScreen({super.key});

  @override
  State<CriarChurrascoScreen> createState() => _CriarChurrascoScreenState();
}

class _CriarChurrascoScreenState extends State<CriarChurrascoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _localController = TextEditingController();
  final _convidadosController = TextEditingController();
  final _observacoesController = TextEditingController();

  DateTime _dataSelecionada = DateTime.now().add(const Duration(days: 1));

  String _formatarData(DateTime data) {
    final dia = data.day.toString().padLeft(2, '0');
    final mes = data.month.toString().padLeft(2, '0');
    return '$dia/$mes/${data.year}';
  }

  Future<void> _selecionarData() async {
    final agora = DateTime.now();
    final dataEscolhida = await showDatePicker(
      context: context,
      firstDate: DateTime(agora.year, agora.month, agora.day),
      lastDate: DateTime(agora.year + 3),
      initialDate: _dataSelecionada,
    );

    if (dataEscolhida == null) return;

    setState(() {
      _dataSelecionada = dataEscolhida;
    });
  }

  void _salvarChurrasco() {
    final formularioValido = _formKey.currentState?.validate() ?? false;
    if (!formularioValido) return;

    final novoChurrasco = Churrasco(
      id: DateTime.now().toIso8601String(),
      nome: _nomeController.text.trim(),
      data: _dataSelecionada,
      local: _localController.text.trim(),
      quantidadeConvidados: int.tryParse(_convidadosController.text) ?? 1,
      observacoes: _observacoesController.text.trim(),
    );

    Navigator.of(context).pop(novoChurrasco);
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _localController.dispose();
    _convidadosController.dispose();
    _observacoesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Criar Churrasco'),
        backgroundColor: Colors.redAccent,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(
                  labelText: 'Nome do churrasco',
                  hintText: 'Ex: Churrasco da Familia',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Informe o nome do churrasco';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.calendar_month),
                  title: const Text('Data do churrasco'),
                  subtitle: Text(_formatarData(_dataSelecionada)),
                  trailing: TextButton(
                    onPressed: _selecionarData,
                    child: const Text('Alterar'),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _localController,
                decoration: const InputDecoration(
                  labelText: 'Local',
                  hintText: 'Ex: Casa do Joao',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Informe o local';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _convidadosController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Quantidade de convidados',
                  hintText: 'Ex: 12',
                ),
                validator: (value) {
                  final qtd = int.tryParse(value ?? '');
                  if (qtd == null || qtd <= 0) {
                    return 'Informe um numero maior que zero';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _observacoesController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Observacoes',
                  hintText: 'Ex: Levar gelo e carvao extra',
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _salvarChurrasco,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  icon: const Icon(Icons.save),
                  label: const Text('Salvar Churrasco'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}