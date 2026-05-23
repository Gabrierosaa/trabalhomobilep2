import 'package:flutter/material.dart';

import '../models/item_compra.dart';

class ItemWidget extends StatelessWidget {
  const ItemWidget({
    super.key,
    required this.item,
    required this.aoMudarStatus,
    required this.aoEditar,
    required this.aoDeletar,
  });

  final ItemCompra item;
  final VoidCallback aoMudarStatus;
  final VoidCallback aoEditar;
  final VoidCallback aoDeletar;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: ListTile(
        leading: Checkbox(
          value: item.foiComprado,
          activeColor: Colors.redAccent,
          onChanged: (_) => aoMudarStatus(),
        ),
        title: Text(
          item.nome,
          style: TextStyle(
            decoration: item.foiComprado ? TextDecoration.lineThrough : null,
            color: item.foiComprado ? Colors.grey : Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text('Quantidade: ${item.quantidade}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              color: Colors.blueGrey,
              onPressed: aoEditar,
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              color: Colors.redAccent,
              onPressed: aoDeletar,
            ),
          ],
        ),
        onTap: aoMudarStatus,
      ),
    );
  }
}
