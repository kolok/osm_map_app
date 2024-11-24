import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:jean_jean/presentation/business_logic/models/aaction.dart';
import 'package:jean_jean/presentation/business_logic/services/lvao_api.dart';

import 'aaction_test.mocks.dart';

// TODO : le mock ne marche pas
@GenerateMocks([ApiService])
void main() {

  group('AAction 0', () {
    test('getActionList returns a map of actions', () async {

      ApiService mockApiService = MockApiService();

      // Arrange
      final mockActions = [
        {'id': 1, 'code': 'trier', 'libelle': 'Trier'},
        {'id': 2, 'code': 'reparer', 'libelle': 'Réparer'},
      ];
      when(mockApiService.getActionList()).thenAnswer((_) async => mockActions);

      // Act
      final actionList = await AAction.getActionList();

      // Assert
      expect(actionList, isNotNull);
      expect(actionList!.length, 2);
      expect(actionList['trier']!.libelle, 'Trier');
      expect(actionList['reparer']!.libelle, 'Réparer');
    });
  });

  // group('AAction 2', () {
  //   test('returns an AAction list if ApiService.fetchActions is successful', () async {

  //     final client = MockClient();

  //     final mockApiResponse = '[{"id": 1, "code": "trier", "libelle": "Trier"},{"id": 2, "code": "reparer", "libelle": "Réparer"}]';

  //     when(client
  //             .get(Uri.parse(
  //           'https://quefairedemesobjets-preprod.osc-fr1.scalingo.io/api/qfdmo/actions')))
  //         .thenAnswer((_) async =>
  //             http.Response(mockApiResponse, 200));

  //     final actionList = await AAction.getActionList();

  //     // Assert
  //     debugPrint('actionList: $actionList');
  //     expect(actionList, isNotNull);
  //     expect(actionList!.length, 2);
  //     expect(actionList['trier']!.libelle, 'Trier');
  //     expect(actionList['reparer']!.libelle, 'Réparer');
  //   });
  // });
}
