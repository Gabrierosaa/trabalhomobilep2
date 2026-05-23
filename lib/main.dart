import 'package:flutter/material.dart';

import 'screens/lista_compras_screen.dart';

void main() {
  runApp(const AppChurrasco());
}

class AppChurrasco extends StatelessWidget {
  const AppChurrasco({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lista do Churrasco',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.redAccent),
        useMaterial3: true,
      ),
      home: const ListaComprasScreen(),
    );
  }
}
