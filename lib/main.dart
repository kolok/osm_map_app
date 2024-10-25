import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'openstreetmap.dart'; // Importez le fichier openstreetmap.dart

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Carte avec OpenStreetMap',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const CarteScreen(),
    );
  }
}


class CarteScreen extends StatefulWidget {
  const CarteScreen({super.key});

  @override
  CarteScreenState createState() => CarteScreenState();
}

class CarteScreenState extends State<CarteScreen> {
  LatLng _currentPosition = const LatLng(48.8566, 2.3522); // Coordonnées par défaut pour Paris, France
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Vérifiez si les services de localisation sont activés
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Les services de localisation ne sont pas activés, ne continuez pas
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Les permissions sont refusées, ne continuez pas
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Les permissions sont refusées de manière permanente, ne continuez pas
      return;
    }

    // Obtenez la position actuelle de l'utilisateur
    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
      _mapController.move(_currentPosition, 13.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Carte avec OpenStreetMap"),
      ),
      body: OpenStreetMap(
        mapController: _mapController,
        initialPosition: _currentPosition,
      ),
    );
  }
}