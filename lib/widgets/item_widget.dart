import 'package:flutter/material.dart';

import '../models/item_compra.dart';

class ItemWidget extends StatelessWidget {
  const ItemWidget({
    super.key,
    required this.item,
    required this.aoMudarStatus,
  });

  final ItemCompra item;
  final VoidCallback aoMudarStatus;

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
        trailing: Icon(
          item.foiComprado ? Icons.check_circle : Icons.shopping_cart,
          color: item.foiComprado ? Colors.green : Colors.redAccent,
        ),
        onTap: aoMudarStatus,
      ),
    );
  }
}
