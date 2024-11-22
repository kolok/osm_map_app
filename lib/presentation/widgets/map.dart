// lib/presentation/widgets/openstreetmap.dart

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jean_jean/presentation/business_logic/models/aaction.dart';
import 'package:jean_jean/presentation/widgets/createactordialog.dart';
import 'package:jean_jean/presentation/business_logic/models/marker.dart';
import 'package:latlong2/latlong.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:url_launcher/url_launcher.dart';

import '../business_logic/models/acteur.dart';
import '../business_logic/services/lvao_api.dart';
import 'map/slidepanel.dart';
import 'map/zoombuttons.dart'; // Si vous avez un widget ZoomButtons

class OpenStreetMap extends StatefulWidget {
  final MapController mapController;
  final LatLng initialPosition;
  final double zoom;
  final List<int>? actionIds;

  const OpenStreetMap({
    super.key,
    required this.mapController,
    required this.initialPosition,
    required this.zoom,
    this.actionIds,
  });

  @override
  OpenStreetMapState createState() => OpenStreetMapState();
}

class OpenStreetMapState extends State<OpenStreetMap> {
  List<Acteur> _markerData = [];
  final List<Acteur> _localActors = [];
  List<Marker> _markers= [];
  MarkerBuilder _markerBuilder = MarkerBuilder(
    markerData: [],
    localActors: [],
    selectedMarkerId: '',
    onMarkerTap: (markerId) {},
  );
  String _selectedActorName = '';
  String? _selectedMarkerId;
  final PanelController _panelController = PanelController();
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    widget.mapController.mapEventStream.listen((event) {
      if (event is MapEventMoveEnd) {
        var camera = event.camera;
        _fetchMarkers(camera.center.latitude, camera.center.longitude);
      }
    });
    _fetchMarkers(
        widget.initialPosition.latitude, widget.initialPosition.longitude);
  }

  Future<void> _fetchMarkers(double latitude, double longitude) async {
    try {
      final markers = await _apiService.fetchMarkers(
          latitude, longitude, widget.actionIds);
      setState(() {
        _markerData = markers;
      });
    } catch (e) {
      _showErrorDialog('Erreur', e.toString());
    }
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );  }


  void _showAddActorDialog(LatLng position) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Ajouter un acteur'),
          content: Text('Voulez-vous ajouter un acteur de l\'économie circulaire à cet endroit ?'),
          actions: [
            TextButton(
              child: Text('Annuler'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Ajouter'),
              onPressed: () async {
                Navigator.of(context).pop();
                _createActor(position);
              },
            ),
          ],
        );
      },
    );
  }


  void _createActor(LatLng position) async {
  
    // Naviguer vers le CreateActorWidget et attendre le résultat
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CreateActorWidget(position: position),
      ),
    );
  
    // Si le résultat n'est pas nul, ajouter le nouvel acteur au state
    if (result != null) {
      setState(() {
        _localActors.add(Acteur(
          identifiantUnique: result['identifiantUnique'],
          latitude: result['position'].latitude,
          longitude: result['position'].longitude,
          nom: result['nom'],
          actions: [AAction(code: 'reparer', libelle: 'Réparer', id: 0)],
        ));
      });
    }
  }

  void _closePanel() {
    setState(() {
      _selectedActorName = '';
      _selectedMarkerId = null;
    });
    _panelController.close();
  }

  @override
  Widget build(BuildContext context) {

    _markerBuilder = MarkerBuilder(
      markerData: _markerData,
      localActors: _localActors,
      selectedMarkerId: _selectedMarkerId,
      onMarkerTap: (markerId) {
        setState(() {
          final allMarkersData = [..._markerData, ..._localActors];
          _selectedActorName = allMarkersData
              .firstWhere((acteur) => acteur.identifiantUnique == markerId)
              .nom;
          _selectedMarkerId = markerId;
        });
      },
    );

    // Reconstruire les marqueurs avec la taille mise à jour
    _markers = _markerBuilder.buildMarkers();

    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: widget.mapController,
            options: MapOptions(
              initialCenter: widget.initialPosition,
              initialZoom: widget.zoom,
              interactionOptions: InteractionOptions(
                flags: InteractiveFlag.all - InteractiveFlag.rotate
              ),
              onLongPress: (tapPosition, point) {
                _showAddActorDialog(point);
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.app',
              ),
              MarkerLayer(markers: _markers),
              RichAttributionWidget(
                attributions: [
                  TextSourceAttribution(
                    'OpenStreetMap contributors',
                    onTap: () => launchUrl(Uri.parse('https://openstreetmap.org/copyright')),
                  ),
                ],
              ),
              FlutterMapZoomButtons(
                mapController: widget.mapController,
                minZoom: 2,
                maxZoom: 19,
                padding: 5,
                zoomInColor: Colors.grey,
                zoomInColorIcon: Colors.black,
                zoomOutColor: Colors.grey,
                zoomOutColorIcon: Colors.black,
                alignment: Alignment.bottomRight,
              ),
            ],
          ),
          if (_selectedActorName.isNotEmpty)
            SlidingUpPanel(
              controller: _panelController,
              minHeight: MediaQuery.of(context).size.height / 3,
              snapPoint: 0.5,
              maxHeight: MediaQuery.of(context).size.height,
              backdropEnabled: true,
              panel: PanelWidget(onClose: _closePanel,
              selectedActorName: _selectedActorName,

              )
            ),
        ],
      ),
    );
  }
}