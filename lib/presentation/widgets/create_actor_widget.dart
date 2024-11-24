import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_dragmarker/flutter_map_dragmarker.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:latlong2/latlong.dart';

import 'package:jean_jean/presentation/business_logic/services/ban_api.dart';

class CreateActorWidget extends StatefulWidget {
  final LatLng position;

  const CreateActorWidget({super.key, required this.position});

  @override
  CreateActorWidgetState createState() => CreateActorWidgetState();
}

class CreateActorWidgetState extends State<CreateActorWidget> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final MapController _mapController = MapController();
  late LatLng _currentPosition;
  BANApiService banApiService = BANApiService();

  @override
  void initState() {
    super.initState();
    _currentPosition = widget.position;
    _initializeAddress();
  }

  Future<void> _initializeAddress() async {
    final address = await banApiService.getAddressFromLatLng(_currentPosition);
    if (mounted) {
      setState(() {
        _addressController.text = address;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Proposer un nouvel acteur'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            // Champs du formulaire
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Nom'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer un nom';
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            Container(
              height: 300, // Fixe la hauteur de la carte
              child: FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter: _currentPosition,
                  initialZoom: 17,
                ),
                children: [
                  TileLayer(
                    urlTemplate: 'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.app',
                  ),
                  DragMarkers(
                    markers: [
                      DragMarker(
                        size: Size(35.0,50.0),
                        alignment: Alignment.topCenter,
                        point: _currentPosition,
                        offset: const Offset(0.0, -8.0),
                        builder: (_, __, ___) => SvgPicture.asset(
                          'assets/images/pin.svg',
                          fit: BoxFit.fill,
                          allowDrawingOutsideViewBox: true,
                        ),
                        onDragEnd: (details, latLng) async {
                          final String address = await banApiService.getAddressFromLatLng(latLng);
                          if (mounted) {
                            setState(() {
                              _currentPosition = latLng;
                              _addressController.text = address;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ]
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _addressController,
              decoration: InputDecoration(labelText: 'Adresse'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  final actorData = {
                    'identifiantUnique': DateTime.now().toString(),
                    'nom': _nameController.text,
                    'position': _currentPosition,
                  };
                  if (mounted) {
                    Navigator.of(context).pop(actorData);
                  }
                }
              },
              child: Text('Enregistrer'),
            ),
          ],
        ),
      ),
    );
  }
}
