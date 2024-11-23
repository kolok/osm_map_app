import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:jean_jean/presentation/widgets/custom_app_bar_widget.dart';
import 'package:jean_jean/presentation/widgets/map_widget.dart';
import 'package:latlong2/latlong.dart';
import 'jean_trouvou.dart'; // Importez le fichier jean_trouvou.dart

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
      appBar: CustomAppBarWidget(
        title: "Jean Féquoi",
        nextScreen: ({required LatLng initialPosition, required double zoom}) => JeanTrouvou(initialPosition: initialPosition, zoom: zoom),
        mapController: _mapController,
      ),
      body: MapWidget(
        mapController: _mapController,
        initialPosition: widget.initialPosition,
        zoom: widget.zoom,
        actionIds: [ 8, 6, 1, 9, 3, 11, 4 ],
      ),
    );
  }
}
