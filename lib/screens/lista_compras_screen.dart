import 'package:flutter/material.dart';

import '../models/item_compra.dart';
import '../widgets/item_widget.dart';

class ListaComprasScreen extends StatefulWidget {
  const ListaComprasScreen({super.key});

  @override
  State<ListaComprasScreen> createState() => _ListaComprasScreenState();
}

class _ListaComprasScreenState extends State<ListaComprasScreen> {
  final List<ItemCompra> _meusItens = [
    ItemCompra(id: '1', nome: 'Picanha', quantidade: 2),
    ItemCompra(id: '2', nome: 'Pao de Alho', quantidade: 3),
    ItemCompra(id: '3', nome: 'Saco de Carvao', quantidade: 1),
  ];

  final _nomeController = TextEditingController();
  final _qtdController = TextEditingController();

  void _abrirFormularioCadastro() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            top: 20,
            right: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nomeController,
                decoration: const InputDecoration(
                  labelText: 'Nome do Item (Ex: Linguica)',
                ),
              ),
              TextField(
                controller: _qtdController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Quantidade'),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _adicionarNovoItem,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                  ),
                  child: const Text(
                    'Adicionar ao Churrasco',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _adicionarNovoItem() {
    final nomeDigitado = _nomeController.text.trim();
    final qtdDigitada = int.tryParse(_qtdController.text) ?? 1;

    if (nomeDigitado.isEmpty) return;

    final novoItem = ItemCompra(
      id: DateTime.now().toIso8601String(),
      nome: nomeDigitado,
      quantidade: qtdDigitada,
    );

    setState(() {
      _meusItens.add(novoItem);
    });

    _nomeController.clear();
    _qtdController.clear();
    Navigator.of(context).pop();
  }

  void _removerItem(String id) {
    setState(() {
      _meusItens.removeWhere((item) => item.id == id);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Item removido do churrasco!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _qtdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final itensComprados = _meusItens.where((item) => item.foiComprado).length;

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Lista do Churrasco',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            Text(
              '$itensComprados de ${_meusItens.length} itens comprados',
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ],
        ),
        backgroundColor: Colors.redAccent,
      ),
      body: ListView.builder(
        itemCount: _meusItens.length,
        itemBuilder: (context, index) {
          final itemAtual = _meusItens[index];

          return Dismissible(
            key: ValueKey(itemAtual.id),
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20),
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: const Icon(Icons.delete, color: Colors.white, size: 30),
            ),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) {
              _removerItem(itemAtual.id);
            },
            child: ItemWidget(
              item: itemAtual,
              aoMudarStatus: () {
                setState(() {
                  itemAtual.foiComprado = !itemAtual.foiComprado;
                });
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _abrirFormularioCadastro,
        backgroundColor: Colors.redAccent,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
