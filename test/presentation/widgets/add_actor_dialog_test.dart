import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jean_jean/presentation/widgets/add_actor_dialog.dart';

void main() {
  group('AddActorDialog', () {
    testWidgets('displays the title and message', (WidgetTester tester) async {
      // Arrange
      const title = 'Ajouter un acteur';
      const message = 'Voulez-vous ajouter un acteur de l\'économie circulaire à cet endroit ?';
      const addActorDialog = AddActorDialog(
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
                        return addActorDialog;
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

    testWidgets('calls successAction when Ajouter is pressed', (WidgetTester tester) async {
      // Arrange
      bool successActionCalled = false;
      final addActorDialog = AddActorDialog(
        title: 'Ajouter un acteur',
        message: 'Voulez-vous ajouter un acteur de l\'économie circulaire à cet endroit ?',
        successAction: () {
          successActionCalled = true;
        },
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
                        return addActorDialog;
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

      // Press the Ajouter button
      await tester.tap(find.text('Ajouter'));
      await tester.pumpAndSettle();

      // Assert
      expect(successActionCalled, isTrue);
    });

    testWidgets('closes the dialog when Annuler is pressed', (WidgetTester tester) async {
      // Arrange
      const addActorDialog = AddActorDialog(
        title: 'Ajouter un acteur',
        message: 'Voulez-vous ajouter un acteur de l\'économie circulaire à cet endroit ?',
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
                        return addActorDialog;
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

      // Press the Annuler button
      await tester.tap(find.text('Annuler'));
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(AddActorDialog), findsNothing);
    });
  });
}