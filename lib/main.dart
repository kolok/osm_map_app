import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'jean_fequoi.dart'; // Importez le fichier first_screen.dart

void main() {
  runApp(const JeanJean());
}

class JeanJean extends StatefulWidget {
  const JeanJean({super.key});

  @override
  _JeanJeanState createState() => _JeanJeanState();
}

class _JeanJeanState extends State<JeanJean> {
  LatLng _currentPosition = const LatLng(48.8566, 2.3522); // Coordonnées par défaut pour Paris, France

  @override
  void initState() {
    super.initState();
    //_getCurrentLocation();
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
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jean Jean',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: JeanFequoi(initialPosition: _currentPosition),
    );
  }
}