
import 'package:flutter_test/flutter_test.dart';
import 'package:flag_game/main.dart';

void main() {
  testWidgets('O aplicativo mostra o menu principal',
      (WidgetTester tester) async {
    await tester.pumpWidget(const FlagGameApp());
    await tester.pumpAndSettle();

    expect(find.text('FLAG GAME'), findsOneWidget);
  });
}
