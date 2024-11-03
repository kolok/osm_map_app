import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'widgets/custom_app_bar.dart';
import 'widgets/openstreetmap.dart'; // Importez le fichier openstreetmap.dart
import 'jean_fequoi.dart'; // Importez le fichier jean_fequoi.dart

class JeanTrouvou extends StatefulWidget {
  final LatLng initialPosition;

  const JeanTrouvou({super.key, required this.initialPosition});

  @override
  JeanTrouvouState createState() => JeanTrouvouState();
}

class JeanTrouvouState extends State<JeanTrouvou> {
  final MapController _mapController = MapController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Jean Trouvou",
        nextScreen: ({required LatLng initialPosition}) => JeanFequoi(initialPosition: initialPosition),
        mapController: _mapController,
      ),
      body: OpenStreetMap(
        mapController: _mapController,
        initialPosition: widget.initialPosition,
      ),
    );
  }
}