import 'package:jean_jean/presentation/business_logic/services/lvao_api.dart';

class AAction {
  final int id;
  final String code;
  final String libelle;
  static Map<String, AAction>? _actionList;

  AAction({
    required this.id,
    required this.code,
    required this.libelle,
  });

  factory AAction.fromJson(Map<String, dynamic> json) {
    return AAction(
      id: json['id'] as int,
      code: json['code'] as String,
      libelle: json['libelle'] as String,
    );
  }

  static Future<Map<String,AAction>?> getActionList() async {
    if (_actionList != null) {
      return _actionList!;
    }

    List apiResponse = await ApiService().fetchActions();

    final actionList = apiResponse
          .map<AAction>((item) => AAction.fromJson(item))
          .toList();

    _actionList = {};
    for (var action in actionList) {
      _actionList![action.code] = action;
    }

    return _actionList;
  }
}
