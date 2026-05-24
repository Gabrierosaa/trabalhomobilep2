class ItemCompra {
  ItemCompra({
    required this.id,
    required this.nome,
    required this.quantidade,
    this.precoEstimadoUnitario,
    this.foiComprado = false,
  });

  final String id;
  final String nome;
  final int quantidade;
  final double? precoEstimadoUnitario;
  bool foiComprado;
}
