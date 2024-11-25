// lib/presentation/widgets/openstreetmap.dart

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:jean_jean/presentation/business_logic/models/aaction.dart';
import 'package:jean_jean/presentation/widgets/add_actor_dialog.dart';
import 'package:jean_jean/presentation/widgets/create_actor_widget.dart';
import 'package:jean_jean/presentation/business_logic/models/marker.dart';
import 'package:jean_jean/presentation/widgets/error_dialog.dart';
import 'package:latlong2/latlong.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:url_launcher/url_launcher.dart';

import '../business_logic/models/acteur.dart';
import '../business_logic/services/lvao_api.dart';
import 'map/slide_panel_widget.dart';
import 'map/zoom_buttons_widget.dart'; // Si vous avez un widget ZoomButtons

class MapWidget extends StatefulWidget {
  final MapController mapController;
  final LatLng initialPosition;
  final double zoom;
  final List<String>? actionCodes;

  const MapWidget({
    super.key,
    required this.mapController,
    required this.initialPosition,
    required this.zoom,
    this.actionCodes,
  });

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  List<Acteur> _markerData = [];
  final List<Acteur> _localActors = [];
  List<Marker> _markers= [];
  MarkerBuilder _markerBuilder = MarkerBuilder(
    markerData: [],
    localActors: [],
    selectedMarkerId: '',
    actionCodes: [],
    onMarkerTap: (markerId) {},
  );
  // TODO : Utiliser un Objet Acteur directement
  String _selectedActorName = '';
  String? _selectedMarkerId;
  final PanelController _panelController = PanelController();
  // TODO : utiliser _actionMap ?
  // Map<String, AAction>? _actionMap = {};
  final List<int> _actionIds = [];

  @override
  void initState() {
    super.initState();
    _initializeActors();
    widget.mapController.mapEventStream.listen((event) {
      if (event is MapEventMoveEnd) {
        var camera = event.camera;
        _fetchMarkerData(camera.center.latitude, camera.center.longitude);
      }
    });
  }

  _initializeActors() async {
    await _findActionIds();
    await _fetchMarkerData(
        widget.initialPosition.latitude, widget.initialPosition.longitude);
  }

  Future<void> _findActionIds() async{
    if (widget.actionCodes == null) {
      return;
    }
    final actionIds = <int>[];
    Map<String,AAction>? actions = await AAction.getActionList();
    for (final code in widget.actionCodes!) {
      final action = actions![code];
      actionIds.add(action!.id);
    }
    if (mounted) {
      setState(() {
        _actionIds.addAll(actionIds);
      });
    }
  }

  Future<void> _fetchMarkerData(double latitude, double longitude) async {
    try {
      final markers = await Acteur.getActeurList(
          latitude, longitude, _actionIds);
      if (mounted) {
        setState(() {
          _markerData = markers;
        });
      }
    } catch (e) {
      _showErrorDialog('Erreur', e.toString());
    }
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ErrorDialog(
          title: title,
          message: message,
        );
      },
    );
  }


  void _showAddActorDialog(LatLng position) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddActorDialog(
          title: 'Ajouter un acteur',
          message: 'Voulez-vous ajouter un acteur de l\'économie circulaire à cet endroit ?',
          successAction: () {
            _createActor(position);
          },
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
      if (mounted) {
        setState(() {
          _localActors.add(Acteur(
            identifiantUnique: result['identifiantUnique'],
            latitude: result['position'].latitude,
            longitude: result['position'].longitude,
            nom: result['nom'],
            actions: [],
          ));
        });
      }  
    }
  }

  void _closePanel() {
    if (mounted) {
      setState(() {
        _selectedActorName = '';
        _selectedMarkerId = null;
      });
    }
    _panelController.close();
  }

  @override
  Widget build(BuildContext context) {

    _markerBuilder = MarkerBuilder(
      markerData: _markerData,
      localActors: _localActors,
      selectedMarkerId: _selectedMarkerId,
      actionCodes: widget.actionCodes,
      onMarkerTap: (markerId) {
        if (mounted) {
          setState(() {
            final allMarkersData = [..._markerData, ..._localActors];
            _selectedActorName = allMarkersData
                .firstWhere((acteur) => acteur.identifiantUnique == markerId)
                .nom;
            _selectedMarkerId = markerId;
          });
        }
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
              ZoomButtonsWidget(
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
              panel: SlidePanelWidget(onClose: _closePanel,
              selectedActorName: _selectedActorName,

              )
            ),
        ],
      ),
    );
  }
}