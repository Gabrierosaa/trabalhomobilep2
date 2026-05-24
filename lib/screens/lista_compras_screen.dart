import 'dart:math';

import 'package:flutter/material.dart';

import '../models/churrasco.dart';
import '../models/item_compra.dart';
import '../widgets/item_widget.dart';
import 'criar_churrasco_screen.dart';

enum TemaChurrasco { tradicional, praia, noturno }

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
  final _precoController = TextEditingController();

  Churrasco? _churrascoAtual;
  TemaChurrasco _temaAtual = TemaChurrasco.tradicional;

  Color get _corPrincipal {
    switch (_temaAtual) {
      case TemaChurrasco.tradicional:
        return Colors.redAccent;
      case TemaChurrasco.praia:
        return Colors.teal;
      case TemaChurrasco.noturno:
        return Colors.deepPurple;
    }
  }

  Color get _corSecundaria {
    switch (_temaAtual) {
      case TemaChurrasco.tradicional:
        return Colors.orangeAccent;
      case TemaChurrasco.praia:
        return Colors.cyan;
      case TemaChurrasco.noturno:
        return Colors.indigo;
    }
  }

  String get _nomeTema {
    switch (_temaAtual) {
      case TemaChurrasco.tradicional:
        return 'Tradicional';
      case TemaChurrasco.praia:
        return 'Praia';
      case TemaChurrasco.noturno:
        return 'Noturno';
    }
  }

  String _formatarData(DateTime data) {
    final dia = data.day.toString().padLeft(2, '0');
    final mes = data.month.toString().padLeft(2, '0');
    return '$dia/$mes/${data.year}';
  }

  String _formatarReais(double valor) {
    return valor.toStringAsFixed(2).replaceAll('.', ',');
  }

  double _parsePreco(String texto) {
    final normalizado = texto
        .replaceAll('R\$', '')
        .replaceAll(' ', '')
        .replaceAll('.', '')
        .replaceAll(',', '.');
    return double.tryParse(normalizado) ?? 0;
  }

  double get _valorTotalEstimado {
    return _meusItens.fold(
      0.0,
      (soma, item) => soma + (item.quantidade * (item.precoEstimadoUnitario ?? 0)),
    );
  }

  double get _custoPorConvidado {
    final convidados = _churrascoAtual?.quantidadeConvidados ?? 0;
    if (convidados == 0) return 0;
    return _valorTotalEstimado / convidados;
  }

  int get _diasParaChurrasco {
    if (_churrascoAtual == null) return 0;
    final hoje = DateTime.now();
    final baseHoje = DateTime(hoje.year, hoje.month, hoje.day);
    final dataEvento = DateTime(
      _churrascoAtual!.data.year,
      _churrascoAtual!.data.month,
      _churrascoAtual!.data.day,
    );
    return dataEvento.difference(baseHoje).inDays;
  }

  Future<void> _abrirTelaCriarChurrasco() async {
    final churrascoCriado = await Navigator.of(context).push<Churrasco>(
      MaterialPageRoute(
        builder: (_) => const CriarChurrascoScreen(),
      ),
    );

    if (!mounted || churrascoCriado == null) return;

    setState(() {
      _churrascoAtual = churrascoCriado;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Churrasco "${churrascoCriado.nome}" criado!'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _adicionarSugestoesInteligentes() {
    final convidados = _churrascoAtual?.quantidadeConvidados ?? 10;
    final sugestoes = <ItemCompra>[
      ItemCompra(
        id: DateTime.now().add(const Duration(milliseconds: 1)).toIso8601String(),
        nome: 'Refrigerante',
        quantidade: (convidados / 3).ceil(),
        precoEstimadoUnitario: 9.9,
      ),
      ItemCompra(
        id: DateTime.now().add(const Duration(milliseconds: 2)).toIso8601String(),
        nome: 'Gelo',
        quantidade: (convidados / 4).ceil(),
        precoEstimadoUnitario: 12.0,
      ),
      ItemCompra(
        id: DateTime.now().add(const Duration(milliseconds: 3)).toIso8601String(),
        nome: 'Farofa',
        quantidade: (convidados / 6).ceil(),
        precoEstimadoUnitario: 8.5,
      ),
    ];

    final itensExistentes = _meusItens.map((item) => item.nome.toLowerCase()).toSet();
    final itensParaAdicionar = sugestoes
        .where((sugestao) => !itensExistentes.contains(sugestao.nome.toLowerCase()))
        .toList();

    if (itensParaAdicionar.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('As sugestoes ja estao na lista.')),
      );
      return;
    }

    setState(() {
      _meusItens.addAll(itensParaAdicionar);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${itensParaAdicionar.length} sugestoes adicionadas!')),
    );
  }

  void _recomendarProximoItem() {
    final pendentes = _meusItens.where((item) => !item.foiComprado).toList();

    if (pendentes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tudo comprado. Churrasco pronto!')),
      );
      return;
    }

    final recomendado = pendentes[Random().nextInt(pendentes.length)];

    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Proximo Item Recomendado'),
        content: Text('Compre agora: ${recomendado.nome} (x${recomendado.quantidade})'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  void _abrirFormularioEdicao(ItemCompra item) {
    _nomeController.text = item.nome;
    _qtdController.text = item.quantidade.toString();
    final precoAtual = item.precoEstimadoUnitario ?? 0;
    _precoController.text = precoAtual > 0
      ? precoAtual.toStringAsFixed(2).replaceAll('.', ',')
        : '';

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
                  labelText: 'Nome do Item',
                ),
              ),
              TextField(
                controller: _qtdController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Quantidade'),
              ),
              TextField(
                controller: _precoController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Preco unitario (opcional)',
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _editarItem(item.id),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _corPrincipal,
                  ),
                  child: const Text(
                    'Salvar Alteracoes',
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

  void _abrirFormularioCadastro() {
    _nomeController.clear();
    _qtdController.clear();
    _precoController.clear();

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
              TextField(
                controller: _precoController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Preco unitario (opcional)',
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _adicionarNovoItem,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _corPrincipal,
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
    final precoDigitado = _parsePreco(_precoController.text);

    if (nomeDigitado.isEmpty) return;

    final novoItem = ItemCompra(
      id: DateTime.now().toIso8601String(),
      nome: nomeDigitado,
      quantidade: qtdDigitada,
      precoEstimadoUnitario: precoDigitado,
    );

    setState(() {
      _meusItens.add(novoItem);
    });

    _nomeController.clear();
    _qtdController.clear();
    _precoController.clear();
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

  void _editarItem(String id) {
    final nomeDigitado = _nomeController.text.trim();
    final qtdDigitada = int.tryParse(_qtdController.text) ?? 1;
    final precoDigitado = _parsePreco(_precoController.text);

    if (nomeDigitado.isEmpty) return;

    final index = _meusItens.indexWhere((item) => item.id == id);
    if (index == -1) return;

    setState(() {
      _meusItens[index] = ItemCompra(
        id: _meusItens[index].id,
        nome: nomeDigitado,
        quantidade: qtdDigitada,
        precoEstimadoUnitario: precoDigitado,
        foiComprado: _meusItens[index].foiComprado,
      );
    });

    _nomeController.clear();
    _qtdController.clear();
    _precoController.clear();
    Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Item atualizado com sucesso!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _qtdController.dispose();
    _precoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final itensComprados = _meusItens.where((item) => item.foiComprado).length;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _churrascoAtual?.nome ?? 'Lista do Churrasco',
              style: const TextStyle(color: Colors.white, fontSize: 20),
            ),
            Text(
              _churrascoAtual == null
                  ? '$itensComprados de ${_meusItens.length} itens comprados'
                  : '${_formatarData(_churrascoAtual!.data)} | ${_churrascoAtual!.quantidadeConvidados} convidados',
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: _abrirTelaCriarChurrasco,
            icon: const Icon(Icons.event, color: Colors.white),
            tooltip: 'Criar churrasco',
          ),
          PopupMenuButton<TemaChurrasco>(
            onSelected: (tema) {
              setState(() {
                _temaAtual = tema;
              });
            },
            icon: const Icon(Icons.palette, color: Colors.white),
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: TemaChurrasco.tradicional,
                child: Text('Tema Tradicional'),
              ),
              PopupMenuItem(
                value: TemaChurrasco.praia,
                child: Text('Tema Praia'),
              ),
              PopupMenuItem(
                value: TemaChurrasco.noturno,
                child: Text('Tema Noturno'),
              ),
            ],
          ),
        ],
        backgroundColor: _corPrincipal,
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            margin: const EdgeInsets.fromLTRB(10, 10, 10, 4),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [_corPrincipal, _corSecundaria],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tema: $_nomeTema',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  _churrascoAtual == null
                      ? 'Crie um churrasco para habilitar planejamento avancado.'
                      : _diasParaChurrasco <= 0
                          ? 'O churrasco e hoje!'
                          : 'Faltam $_diasParaChurrasco dia(s) para o churrasco.',
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: _adicionarSugestoesInteligentes,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: _corPrincipal,
                        ),
                        icon: const Icon(Icons.auto_awesome),
                        label: const Text('Sugestao Inteligente'),
                      ),
                      const SizedBox(width: 8),
                      OutlinedButton.icon(
                        onPressed: _recomendarProximoItem,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Colors.white70),
                        ),
                        icon: const Icon(Icons.casino),
                        label: const Text('Proximo Item'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (_churrascoAtual != null)
            Container(
              width: double.infinity,
              margin: const EdgeInsets.fromLTRB(10, 10, 10, 4),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _churrascoAtual!.local,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Data: ${_formatarData(_churrascoAtual!.data)}',
                    style: const TextStyle(color: Colors.black54),
                  ),
                  if (_churrascoAtual!.observacoes.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      'Obs: ${_churrascoAtual!.observacoes}',
                      style: const TextStyle(color: Colors.black54),
                    ),
                  ],
                ],
              ),
            ),
          Container(
            width: double.infinity,
            margin: const EdgeInsets.fromLTRB(10, 6, 10, 6),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Wrap(
              spacing: 16,
              runSpacing: 8,
              children: [
                Text('Itens comprados: $itensComprados/${_meusItens.length}'),
                Text('Custo estimado: R\$ ${_formatarReais(_valorTotalEstimado)}'),
                if (_churrascoAtual != null)
                  Text('Por convidado: R\$ ${_formatarReais(_custoPorConvidado)}'),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
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
                    aoEditar: () => _abrirFormularioEdicao(itemAtual),
                    aoDeletar: () => _removerItem(itemAtual.id),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _abrirFormularioCadastro,
        backgroundColor: _corPrincipal,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
