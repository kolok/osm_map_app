// lib/presentation/widgets/openstreetmap/marker_builder.dart

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:latlong2/latlong.dart';

import 'acteur.dart';
import 'aaction.dart';

// TODO : Utiliser les actions visibles sur la carte pour sélectionner l'icône de l'acteur
class MarkerBuilder {
  final List<Acteur> markerData;
  final List<Acteur> localActors;
  final String? selectedMarkerId;
  final Function(String) onMarkerTap;
  final List<String>? actionCodes;

  MarkerBuilder({
    required this.markerData,
    required this.localActors,
    required this.selectedMarkerId,
    required this.onMarkerTap,
    required this.actionCodes,
  });

  List<Marker> buildMarkers() {
    final allMarkers = [...markerData, ...localActors];

    _reorderMarkers(allMarkers);

    return allMarkers.map((item) {
      final markerId = item.identifiantUnique;
      final isSelected = selectedMarkerId == markerId;
      final iconPath = _getIconPath(item.actions);
      return Marker(
        key: ValueKey(markerId),
        width: isSelected ? 49.0 : 35.0,
        height: isSelected ? 70.0 : 50.0,
        point: LatLng(item.latitude, item.longitude),
        alignment: Alignment.topCenter,
        child: GestureDetector(
          onTap: () {
            onMarkerTap(markerId);
          },
          child: SvgPicture.asset(
            iconPath,
            fit: BoxFit.fill,
            allowDrawingOutsideViewBox: true,
          ),
        ),
      );
    }).toList();
  }

  String _getIconPath(List<AAction> actions) {
    const actionIconMap = {
      'reparer': 'assets/images/pin_reparer.svg',
      'donner': 'assets/images/pin_donner_echanger.svg',
      'echanger': 'assets/images/pin_donner_echanger.svg',
      'preter': 'assets/images/pin_preter_emprunter_louer.svg',
      'emprunter': 'assets/images/pin_preter_emprunter_louer.svg',
      'louer': 'assets/images/pin_preter_emprunter_louer.svg',
      'mettreenlocation': 'assets/images/pin_preter_emprunter_louer.svg',
      'acheter': 'assets/images/pin_acheter_vendre.svg',
      'revendre': 'assets/images/pin_acheter_vendre.svg',
      'trier': 'assets/images/pin_trier.svg',
    };

    for (var action in actions) {
      if (actionIconMap.containsKey(action.code)) {
        if (actionCodes == null || actionCodes!.contains(action.code)) {
          return actionIconMap[action.code]!;
        }
      }
    }
    return 'assets/images/pin.svg';
  }

  void _reorderMarkers(List<Acteur> allMarkers) {

    allMarkers.sort((a, b) {
      if (a.identifiantUnique == selectedMarkerId) {
        return 1;
      } else if (b.identifiantUnique == selectedMarkerId) {
        return -1;
      } else {
        return 0;
      }
    });

  }
}