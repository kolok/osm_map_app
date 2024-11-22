// lib/presentation/business_logic/services/api_service.dart

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/acteur.dart';

class ApiService {
  static const Duration requestTimeout = Duration(seconds: 30);

  Future<List<Acteur>> fetchMarkers(
      double latitude, double longitude, List<int>? actionIds) async {
    String actions = '';
    if (actionIds != null) {
      actions = actionIds.map((id) => '&actions=$id').join('&');
    }

    final response = await http
        .get(Uri.parse(
            'https://quefairedemesobjets-preprod.osc-fr1.scalingo.io/api/qfdmo/acteurs?latitude=$latitude&longitude=$longitude$actions&limit=25'))
        .timeout(requestTimeout);
    debugPrint('https://quefairedemesobjets-preprod.osc-fr1.scalingo.io/api/qfdmo/acteurs?latitude=$latitude&longitude=$longitude$actions&limit=25');
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      debugPrint('response.body: $data');
      List<Acteur> acteurs = (data['items'] as List)
          .map((item) => Acteur.fromJson(item))
          .toList();

      // Dédupliquer les items selon la clé identifiant_unique
      final uniqueActeurs = <String, Acteur>{};
      for (var acteur in acteurs) {
        uniqueActeurs[acteur.identifiantUnique] = acteur;
      }

      return uniqueActeurs.values.toList();
    } else {
      throw Exception('Erreur ${response.statusCode}');
    }
  }
}