import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trabalhomobilep2/main.dart';

void main() {
  testWidgets('mostra a lista inicial do churrasco', (tester) async {
    await tester.pumpWidget(const AppChurrasco());

    expect(find.text('Lista do Churrasco'), findsOneWidget);
    expect(find.text('0 de 3 itens comprados'), findsOneWidget);
    expect(find.text('Picanha'), findsOneWidget);
    expect(find.text('Pao de Alho'), findsOneWidget);
    expect(find.text('Saco de Carvao'), findsOneWidget);
  });

  testWidgets('adiciona e marca item como comprado', (tester) async {
    await tester.pumpWidget(const AppChurrasco());

    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.widgetWithText(TextField, 'Nome do Item (Ex: Linguica)'),
      'Refrigerante',
    );
    await tester.enterText(find.widgetWithText(TextField, 'Quantidade'), '4');
    await tester.tap(find.text('Adicionar ao Churrasco'));
    await tester.pumpAndSettle();

    expect(find.text('Refrigerante'), findsOneWidget);
    expect(find.text('0 de 4 itens comprados'), findsOneWidget);

    await tester.tap(find.text('Refrigerante'));
    await tester.pump();

    expect(find.text('1 de 4 itens comprados'), findsOneWidget);
  });
}
