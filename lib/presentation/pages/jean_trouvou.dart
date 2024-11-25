import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:jean_jean/presentation/widgets/custom_app_bar_widget.dart';
import 'package:jean_jean/presentation/widgets/map_widget.dart';
import 'package:latlong2/latlong.dart';
import 'jean_fequoi.dart'; // Importez le fichier jean_fequoi.dart

class JeanTrouvou extends StatefulWidget {
  final LatLng initialPosition;
  final double zoom;

  const JeanTrouvou({super.key, required this.initialPosition, required this.zoom});

  @override
  JeanTrouvouState createState() => JeanTrouvouState();
}

class JeanTrouvouState extends State<JeanTrouvou> {
  final MapController _mapController = MapController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(
        title: "Jean Trouvou",
        nextScreen: ({required LatLng initialPosition, required double zoom}) => JeanFequoi(initialPosition: initialPosition, zoom: zoom),
        mapController: _mapController,
      ),
      body: MapWidget(
        mapController: _mapController,
        initialPosition: widget.initialPosition,
        zoom: widget.zoom,
        // TODO : Utiliser les codes au lieu des ids
        // actionIds: [ 7, 5, 9, 2 ],
        actionCodes: [ 'echanger', 'emprunter', 'louer', 'acheter' ],
      ),
    );
  }
}
