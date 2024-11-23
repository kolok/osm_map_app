import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jean_jean/presentation/widgets/map/slide_panel_widget.dart';

void main() {
  group('PanelWidget', () {
    testWidgets('displays the selected actor name', (WidgetTester tester) async {
      // Arrange
      const selectedActorName = 'Test Actor';
      final panelWidget = SlidePanelWidget(
        selectedActorName: selectedActorName,
        onClose: () {},
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: panelWidget,
          ),
        ),
      );

      // Assert
      expect(find.text(selectedActorName), findsOneWidget);
    });

    testWidgets('calls onClose when close button is pressed', (WidgetTester tester) async {
      // Arrange
      bool onCloseCalled = false;
      final panelWidget = SlidePanelWidget(
        selectedActorName: 'Test Actor',
        onClose: () {
          onCloseCalled = true;
        },
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: panelWidget,
          ),
        ),
      );
      await tester.tap(find.byIcon(Icons.close));
      await tester.pump();

      // Assert
      expect(onCloseCalled, isTrue);
    });
  });
}