class ItemCompra {
  ItemCompra({
    required this.id,
    required this.nome,
    required this.quantidade,
    this.foiComprado = false,
  });

  final String id;
  final String nome;
  final int quantidade;
  bool foiComprado;
}
