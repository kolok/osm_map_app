import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jean_jean/presentation/widgets/error_dialog.dart';

void main() {
  group('ErrorDialog', () {
    testWidgets('displays the title and message', (WidgetTester tester) async {
      // Arrange
      const title = 'Erreur';
      const message = 'Une erreur est survenue';
      const errorDialog = ErrorDialog(
        title: title,
        message: message,
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (BuildContext context) {
                return ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return errorDialog;
                      },
                    );
                  },
                  child: Text('Show Dialog'),
                );
              },
            ),
          ),
        ),
      );

      // Open the dialog
      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text(title), findsOneWidget);
      expect(find.text(message), findsOneWidget);
    });

    testWidgets('closes the dialog when OK is pressed', (WidgetTester tester) async {
      // Arrange
      const errorDialog = ErrorDialog(
        title: 'Erreur',
        message: 'Une erreur est survenue',
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (BuildContext context) {
                return ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return errorDialog;
                      },
                    );
                  },
                  child: Text('Show Dialog'),
                );
              },
            ),
          ),
        ),
      );

      // Open the dialog
      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      // Press the OK button
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(ErrorDialog), findsNothing);
    });
  });
}