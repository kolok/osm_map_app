import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'plugins/zoombuttons_plugin.dart';

class OpenStreetMap extends StatefulWidget {
  final MapController mapController;
  final LatLng initialPosition;
  final double zoom;

  const OpenStreetMap({
    super.key,
    required this.mapController,
    required this.initialPosition,
    required this.zoom,
  });

  @override
  OpenStreetMapState createState() => OpenStreetMapState();
}

class OpenStreetMapState extends State<OpenStreetMap> {
  List<dynamic> _markerData = [];
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
    final response = await http.get(Uri.parse(
        'https://quefairedemesobjets-preprod.osc-fr1.scalingo.io/api/qfdmo/acteurs?latitude=$latitude&longitude=$longitude&limit=25'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _markerData = data['items'] as List;
      });
    } else {
      throw Exception('Failed to load markers');
    }
  }

  List<Marker> _buildMarkers() {
    return _markerData.map((item) {
      final markerId = item['identifiant_unique'];
      final isSelected = _selectedMarkerId == markerId;
      return Marker(
        width: isSelected ? 80.0 : 66.0,
        height: isSelected ? 100.0 : 81.0,
        point: LatLng(item['latitude'], item['longitude']),
        child: GestureDetector(
          onTap: () {
            setState(() {
              _selectedActorName = item['nom']?.toString() ?? 'Nom non disponible';
              _selectedMarkerId = markerId;
            });
            // Ouvrir le panneau après la mise à jour de l'état
            debugPrint('Open panel `$_selectedActorName`');
            // _panelController.open();
          },
          child: SvgPicture.asset(
            'assets/images/recycle_pin.svg',
            fit: BoxFit.fill,
            allowDrawingOutsideViewBox: true,
          ),
        ),
      );
    }).toList();
  }

  void _closePanel() {
    setState(() {
      _selectedActorName = '';
      _selectedMarkerId = null;
    });
    debugPrint('Close panel');
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
              // onPanelClosed: _closePanel,
              // onPanelSlide: (position) {
              //   if (position < 0.3) {
              //     _closePanel();
              //   }
              // },
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