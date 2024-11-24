// lib/presentation/business_logic/services/api_service.dart

import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/acteur.dart';

//const HOST of API
const String lvaoApiHost = 'https://quefairedemesobjets-preprod.osc-fr1.scalingo.io/api/qfdmo';

class ApiService {
  static const Duration requestTimeout = Duration(seconds: 30);

  Future<List> getActeurList(double latitude, double longitude, List<int>? actionIds) async {
    String actions = '';
    if (actionIds != null) {
      actions = actionIds.map((id) => '&actions=$id').join('&');
    }

    final response = await http
        .get(Uri.parse(
            '$lvaoApiHost/acteurs?latitude=$latitude&longitude=$longitude$actions&limit=25'))
        .timeout(requestTimeout);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return data['items'] as List;

    } else {
      throw Exception('Erreur ${response.statusCode}');
    }
  }

  Future<List> getActionList() async {
    final response = await http
        .get(Uri.parse(
            '$lvaoApiHost/actions'))
        .timeout(requestTimeout);

    if (response.statusCode == 200) {
      return json.decode(response.body);

    } else {
      throw Exception('Erreur ${response.statusCode}');
    }
  }
}