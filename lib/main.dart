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
  JeanJeanState createState() => JeanJeanState();
}

class JeanJeanState extends State<JeanJean> {
  final LatLng _defaultPosition = const LatLng(48.8566, 2.3522); // Coordonnées par défaut pour Paris, France

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<LatLng> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Vérifiez si les services de localisation sont activés
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Les services de localisation ne sont pas activés, ne continuez pas
      return _defaultPosition; // Coordonnées par défaut pour Paris, France
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Les permissions sont refusées, ne continuez pas
        return _defaultPosition; // Coordonnées par défaut pour Paris, France
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Les permissions sont refusées de manière permanente, ne continuez pas
      return _defaultPosition; // Coordonnées par défaut pour Paris, France
    }

    // Obtenez la position actuelle de l'utilisateur
    Position position = await Geolocator.getCurrentPosition();
    return LatLng(position.latitude, position.longitude);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jean Jean',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder<LatLng>(
        future: _getCurrentLocation(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else if (snapshot.hasError) {
            return Scaffold(
              body: Center(
                child: Text('Erreur: ${snapshot.error}'),
              ),
            );
          } else if (snapshot.hasData) {
            return JeanFequoi(initialPosition: snapshot.data!, zoom: 13.0);
          } else {
            return const Scaffold(
              body: Center(
                child: Text('Impossible d\'obtenir la localisation'),
              ),
            );
          }
        },
      ),
    );
  }
}