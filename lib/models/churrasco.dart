class Churrasco {
  Churrasco({
    required this.id,
    required this.nome,
    required this.data,
    required this.local,
    required this.quantidadeConvidados,
    required this.observacoes,
  });

  final String id;
  final String nome;
  final DateTime data;
  final String local;
  final int quantidadeConvidados;
  final String observacoes;
}