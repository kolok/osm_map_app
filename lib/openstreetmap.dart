import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import 'zoombuttons_plugin.dart'; // Importez le fichier zoombuttons_plugin.dart

class OpenStreetMap extends StatelessWidget {
  final MapController mapController;
  final LatLng initialPosition;

  const OpenStreetMap({
    super.key,
    required this.mapController,
    required this.initialPosition,
  });

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: mapController,
      options: MapOptions(
        initialCenter: initialPosition,
        initialZoom: 13.0,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.app',
        ),
        RichAttributionWidget(
          attributions: [
            TextSourceAttribution(
              'OpenStreetMap contributors',
              onTap: () => launchUrl(Uri.parse('https://openstreetmap.org/copyright')),
            ),
          ],
        ),
        FlutterMapZoomButtons(
          mapController: mapController,
          minZoom: 4,
          maxZoom: 19,
          padding: 10,
          alignment: Alignment.bottomRight,
        ),
      ],
    );
  }
}