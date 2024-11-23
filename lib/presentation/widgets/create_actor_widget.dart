import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:latlong2/latlong.dart';

class CreateActorWidget extends StatefulWidget {
  final LatLng position;

  const CreateActorWidget({super.key, required this.position});

  @override
  CreateActorWidgetState createState() => CreateActorWidgetState();
}

class CreateActorWidgetState extends State<CreateActorWidget> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  late LatLng _currentPosition;
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    _currentPosition = widget.position;
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
                  initialZoom: 13,
  //                onTap: (_, __) {},
                ),
                children: [
                  TileLayer(
                    urlTemplate: 'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.app',
                  ),
                  MarkerLayer(markers: [
                    Marker(
                      width: 35.0,
                      height: 50.0,
                      point: _currentPosition,
                      alignment: Alignment.topCenter,
                      child: GestureDetector(
                        onTap: () {
  //                        onMarkerTap(markerId);
                        },
                        child: SvgPicture.asset(
                          'assets/images/pin.svg',
                          fit: BoxFit.fill,
                          allowDrawingOutsideViewBox: true,
                        ),
                      ),
                    ),
                  ])
                ]
              ),
            ),
            SizedBox(height: 20),
            // Autres champs
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  final actorData = {
                    'identifiantUnique': DateTime.now().toString(),
                    'nom': _nameController.text,
                    'position': widget.position,
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






//       body: Column(
//         children: [
//           Expanded(
//             flex: 2,
//             child: FlutterMap(
//               mapController: _mapController,
//               options: MapOptions(
//                 initialCenter: _currentPosition,
//                 initialZoom: 13,
// //                onTap: (_, __) {},
//               ),
//               children: [
//                 TileLayer(
//                   urlTemplate: 'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png',
//                   userAgentPackageName: 'com.example.app',
//                 ),
//                 MarkerLayer(markers: [
//                   Marker(
//                     width: 35.0,
//                     height: 50.0,
//                     point: _currentPosition,
//                     alignment: Alignment.topCenter,
//                     child: GestureDetector(
//                       onTap: () {
// //                        onMarkerTap(markerId);
//                       },
//                       child: SvgPicture.asset(
//                         'assets/images/pin.svg',
//                         fit: BoxFit.fill,
//                         allowDrawingOutsideViewBox: true,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//           Expanded(
//             flex: 3,
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Form(
//                 key: _formKey,
//                 child: Column(
//                   children: [
//                     TextFormField(
//                       controller: _nameController,
//                       decoration: InputDecoration(labelText: 'Nom de l\'acteur'),
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Veuillez entrer un nom';
//                         }
//                         return null;
//                       },
//                     ),
//                     SizedBox(height: 20),
//                     ElevatedButton(
//                       onPressed: () {
//                         if (_formKey.currentState!.validate()) {
//                           final actorData = {
//                             'nom': _nameController.text,
//                             'position': _currentPosition,
//                           };
//                           Navigator.of(context).pop(actorData);
//                         }
//                       },
//                       child: Text('Enregistrer'),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
