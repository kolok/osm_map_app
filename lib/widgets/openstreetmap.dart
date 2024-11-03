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
  List<Marker> _markers = [];
  String _selectedActorName = '';
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
        _markers = (data['items'] as List).map((item) {
          return Marker(
            width: 66.0,
            height: 81.0,
            point: LatLng(item['latitude'], item['longitude']),

            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedActorName =  item['nom']?.toString() ?? 'Nom non disponible';
                });
              },
              child: SvgPicture.asset(
                'assets/images/recycle_pin.svg',
                fit: BoxFit.fill,
                allowDrawingOutsideViewBox: true,
                width: 66.0, // Ajustez la taille de l'image SVG
                height: 81.0, // Ajustez la taille de l'image SVG
              ),
            ),
          );
        }).toList();
      });
    } else {
      throw Exception('Failed to load markers');
    }
  }

  @override
  Widget build(BuildContext context) {
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
                padding: 10,
                alignment: Alignment.bottomRight,
              ),
            ],
          ),
          if (_selectedActorName.isNotEmpty)
            SlidingUpPanel(
              controller: _panelController,
              minHeight: MediaQuery.of(context).size.height / 3,
              maxHeight: MediaQuery.of(context).size.height,
              panel: Center(
                child: Column(
                  children: [
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        _panelController.close();
                        setState(() {
                          _selectedActorName = '';
                        });
                      },
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