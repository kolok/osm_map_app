// lib/presentation/business_logic/services/api_service.dart

import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';


//const HOST of API
// curl "https://api-adresse.data.gouv.fr/reverse/?lon=2.37&lat=48.357"
const String banApiHost = 'https://api-adresse.data.gouv.fr';

class BANApiService {
  static const Duration requestTimeout = Duration(seconds: 30);

  Future<String> getAddressFromLatLng(LatLng point) async {
    var latitude = point.latitude;
    var longitude = point.longitude;
    print('$banApiHost/reverse/?lat=$latitude&lon=$longitude');
    final response = await http
        .get(Uri.parse(
            '$banApiHost/reverse?lat=$latitude&lon=$longitude'))
        .timeout(requestTimeout);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['features'][0]['properties']['label'];
    } else {
      throw Exception('Erreur ${response.statusCode}');
    }
  }
}