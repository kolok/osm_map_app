import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'widgets/openstreetmap.dart'; // Importez le fichier openstreetmap.dart
import 'jean_trouvou.dart'; // Importez le fichier jean_trouvou.dart
import 'widgets/custom_app_bar.dart'; // Importez le fichier custom_app_bar.dart

class JeanFequoi extends StatefulWidget {
  final LatLng initialPosition;
  final double zoom;

  const JeanFequoi({super.key, required this.initialPosition, required this.zoom});

  @override
  JeanFequoiState createState() => JeanFequoiState();
}

class JeanFequoiState extends State<JeanFequoi> {
  final MapController _mapController = MapController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Jean Féquoi",
        nextScreen: ({required LatLng initialPosition, required double zoom}) => JeanTrouvou(initialPosition: initialPosition, zoom: zoom),
        mapController: _mapController,
      ),
      body: OpenStreetMap(
        mapController: _mapController,
        initialPosition: widget.initialPosition,
        zoom: widget.zoom,
        actionIds: [ 8, 6, 1, 9, 3, 11, 4 ],
      ),
    );
  }
}

  // ACTION
  // {
  //   "id": 8,
  //   "code": "preter",
  // },
  // {
  //   "id": 6,
  //   "code": "mettreenlocation",
  // },
  // {
  //   "id": 1,
  //   "code": "reparer",
  // },
  // {
  //   "id": 9,
  //   "code": "echanger",
  // },
  // {
  //   "id": 3,
  //   "code": "revendre",
  // },
  // {
  //   "id": 11,
  //   "code": "trier",
  // }
  // {
  //   "id": 4,
  //   "code": "donner",
  // },
