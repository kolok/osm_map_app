import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:latlong2/latlong.dart';

import '../../business_logic/models/acteur.dart';

class MarkerWidget extends StatelessWidget {
  final Acteur acteur;
  final bool isSelected;
  final VoidCallback onTap;

  const MarkerWidget({
    super.key,
    required this.acteur,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final iconPath = _getIconPath(acteur.actions);
    return GestureDetector(
      onTap: onTap,
      child: SvgPicture.asset(
        iconPath,
        colorFilter: ColorFilter.mode(
          isSelected ? Colors.red : Colors.blue,
          BlendMode.srcIn,
        ),
        fit: BoxFit.fill,
        allowDrawingOutsideViewBox: true,
      ),
    );
  }

  String _getIconPath(List<AAction> actions) {
    // Votre implémentation de _getIconPath
    return 'assets/images/default_icon.svg';
  }
}