import 'main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'widgets/custom_app_bar.dart';
import 'widgets/openstreetmap.dart'; // Importez le fichier openstreetmap.dart

class SecondScreen extends StatefulWidget {
  const SecondScreen({super.key});

  @override
  SecondScreenState createState() => SecondScreenState();
}

class SecondScreenState extends State<SecondScreen> {
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
      appBar: const CustomAppBar(
        title: "Jean Trouvou",
        nextScreen: CarteScreen(),
      ),
      body: OpenStreetMap(
        mapController: _mapController,
        initialPosition: _currentPosition,
      ),
    );
  }
}