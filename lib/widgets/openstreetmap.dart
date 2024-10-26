import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'plugins/zoombuttons_plugin.dart';

class OpenStreetMap extends StatefulWidget {
  final MapController mapController;
  final LatLng initialPosition;

  const OpenStreetMap({
    super.key,
    required this.mapController,
    required this.initialPosition,
  });

  @override
  _OpenStreetMapState createState() => _OpenStreetMapState();
}

class _OpenStreetMapState extends State<OpenStreetMap> {
  List<Marker> _markers = [];

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
        'https://quefairedemesobjets-preprod.osc-fr1.scalingo.io/api/qfdmo/acteurs?latitude=$latitude&longitude=$longitude'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _markers = (data['items'] as List).map((item) {
          return Marker(
            width: 80.0,
            height: 80.0,
            point: LatLng(item['latitude'], item['longitude']),
            child: const Icon(Icons.location_on, color: Colors.red), // Add an empty container as the child
          );
        }).toList();
      });
    } else {
      throw Exception('Failed to load markers');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: widget.mapController,
      options: MapOptions(
        initialCenter: widget.initialPosition,
        initialZoom: 13.0,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.app',
        ),
        MarkerLayer(markers: _markers), // Ajoutez ce widget pour afficher les marqueurs
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
          minZoom: 4,
          maxZoom: 19,
          padding: 10,
          alignment: Alignment.bottomRight,
        ),
      ],
    );
  }
}