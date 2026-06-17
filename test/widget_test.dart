import 'package:flutter_test/flutter_test.dart';
import 'package:fin_goals/main.dart'; 

void main() {
  testWidgets('Teste inicial do FinGoals', (WidgetTester tester) async {
    // 1. Constrói o nosso aplicativo com o nome correto
    await tester.pumpWidget(const FinGoalsApp());

    // 2. Verifica se o texto do Dashboard (nosso placeholder atual) está na tela
    expect(find.text('Aqui vai ficar o Dashboard!'), findsOneWidget);
  });
}
