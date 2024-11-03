import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'widgets/openstreetmap.dart'; // Importez le fichier openstreetmap.dart
import 'jean_trouvou.dart'; // Importez le fichier second_screen.dart
import 'widgets/custom_app_bar.dart'; // Importez le fichier custom_app_bar.dart

class JeanFequoi extends StatefulWidget {
  final LatLng initialPosition;

  const JeanFequoi({super.key, required this.initialPosition});

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
        nextScreen: JeanTrouvou(initialPosition: widget.initialPosition),
      ),
      body: OpenStreetMap(
        mapController: _mapController,
        initialPosition: widget.initialPosition,
      ),
    );
  }
}