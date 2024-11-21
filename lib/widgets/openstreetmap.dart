import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'plugins/zoombuttons_plugin.dart';

import 'package:jean_jean/models/acteur.dart';
import 'package:jean_jean/pages/add_actor_form.dart';

final requestTimeout = const Duration(seconds: 30);

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
  List<Acteur> _localActors = [];
  String _selectedActorName = '';
  String? _selectedMarkerId;
  final PanelController _panelController = PanelController();

  @override
  void initState() {
    super.initState();
    widget.mapController.mapEventStream.listen((event) {
      if (event is MapEventMoveEnd) {
        var camera = event.camera;
        _fetchMarkers(camera.center.latitude, camera.center.longitude);
      }
    });
    _fetchMarkers(widget.initialPosition.latitude, widget.initialPosition.longitude);
  }

  Future<void> _fetchMarkers(double latitude, double longitude) async {
    // si actionIds est défini, ajoutez les paramètres de requête &actions=x&actions=y&actions=z
    String actions = '';
    if (widget.actionIds != null) {
      actions = widget.actionIds!.map((id) => '&actions=$id').join('&');
    }

    try {
      final response = await http.get(Uri.parse(
          'https://quefairedemesobjets-preprod.osc-fr1.scalingo.io/api/qfdmo/acteurs?latitude=$latitude&longitude=$longitude$actions&limit=25'))
          .timeout(requestTimeout);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _markerData = (data['items'] as List).map((item) => Acteur.fromJson(item)).toList();
        });
      } else {
        _showErrorDialog('Erreur ${response.statusCode}', 'Impossible de charger les marqueurs.');
      }
    } on TimeoutException catch (_) {
      _showErrorDialog('Erreur de délai', 'La requête a pris trop de temps.');
    } catch (e) {
      _showErrorDialog('Erreur', 'Une erreur s\'est produite.');
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
    );
  }

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
                final result = await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => AddActorForm(position: position),
                  ),
                );
                if (result != null) {
                  setState(() {
                    _localActors.add(Acteur(
                      identifiantUnique: DateTime.now().toString(),
                      latitude: result['position'].latitude,
                      longitude: result['position'].longitude,
                      nom: result['nom'],
                      actions: [AAction(code:'reparer', libelle:'reparer', id:0)], // Ajoutez ici les actions appropriées
                    ));
                  });
                }
              },
            ),
          ],
        );
      },
    );
  }

  String _getIconPath(List<AAction> actions) {
    const actionIconMap = {
      'reparer': 'assets/images/pin_reparer.svg',
      'donner': 'assets/images/pin_donner_echanger.svg',
      'echanger': 'assets/images/pin_donner_echanger.svg',
      'preter': 'assets/images/pin_preter_emprunter_louer.svg',
      'emprunter': 'assets/images/pin_preter_emprunter_louer.svg',
      'louer': 'assets/images/pin_preter_emprunter_louer.svg',
      'miseenlocation': 'assets/images/pin_preter_emprunter_louer.svg',
      'acheter': 'assets/images/pin_acheter_vendre.svg',
      'vendre': 'assets/images/pin_acheter_vendre.svg',
      'trier': 'assets/images/pin_trier.svg',
    };

    for (var action in actions) {
      if (actionIconMap.containsKey(action.code)) {
        return actionIconMap[action.code]!;
      }
    }
    return 'assets/images/pin.svg';
  }

  List<Marker> _buildMarkers() {
    final allMarkers = [..._markerData, ..._localActors];

    return allMarkers.map((item) {
      final markerId = item.identifiantUnique;
      final isSelected = _selectedMarkerId == markerId;
      final iconPath = _getIconPath(item.actions);
      return Marker(
        width: isSelected ? 49.0 : 35.0,
        height: isSelected ? 70.0 : 50.0,
        
        point: LatLng(item.latitude, item.longitude),
        alignment: Alignment.topCenter,
        child: GestureDetector(
          onTap: () {
            setState(() {
              _selectedActorName = item.nom;
              _selectedMarkerId = markerId;
              _reorderMarkers();
            });
          },
          child: SvgPicture.asset(
            iconPath,
            fit: BoxFit.fill,
            allowDrawingOutsideViewBox: true,
          ),
        ),
      );
    }).toList();
  }

  void _reorderMarkers() {
    if (_selectedMarkerId != null) {
      _markerData.sort((a, b) {
        if (a.identifiantUnique == _selectedMarkerId) {
          return 1;
        } else if (b.identifiantUnique == _selectedMarkerId) {
          return -1;
        } else {
          return 0;
        }
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
    // Reconstruire les marqueurs avec la taille mise à jour
    List<Marker> markers = _buildMarkers();

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
              MarkerLayer(markers: markers),
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
              panel: Center(
                child: Column(
                  children: [
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: _closePanel,
                    ),
                    Text(
                      _selectedActorName,
                      style: TextStyle(fontSize: 24),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
