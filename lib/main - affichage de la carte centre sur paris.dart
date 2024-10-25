import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const CarteOpenStreetMapApp());
}

class CarteOpenStreetMapApp extends StatelessWidget {
  const CarteOpenStreetMapApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Carte OpenStreetMap',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const CarteScreen(),
    );
  }
}

class CarteScreen extends StatelessWidget {
  const CarteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Carte avec OpenStreetMap"),
      ),
      body: FlutterMap(
        options: const MapOptions(
          initialCenter: LatLng(48.8566, 2.3522), // Coordonnées pour Paris, France
          initialZoom: 13.0,
        ),
        children: [
          TileLayer( // Display map tiles from any source
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png', // OSMF's Tile Server
            userAgentPackageName: 'com.example.app',
            // And many more recommended properties!
          ),
          RichAttributionWidget( // Include a stylish prebuilt attribution widget that meets all requirments
            attributions: [
              TextSourceAttribution(
                'OpenStreetMap contributors',
                onTap: () => launchUrl(Uri.parse('https://openstreetmap.org/copyright')), // (external)
              ),
              // Also add images...
            ],
          ),
        ],
      ),
    );
  }
}
