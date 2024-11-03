import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget Function({required LatLng initialPosition}) nextScreen;
  final MapController mapController;

  const CustomAppBar({
    super.key,
    required this.title,
    required this.nextScreen,
    required this.mapController,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              final center = mapController.camera.center;
              final zoom = mapController.camera.zoom;
              Navigator.of(context).pushReplacement(_createRoute(nextScreen, center, zoom, AxisDirection.right));
            },
          ),
          Text(title),
          IconButton(
            icon: const Icon(Icons.arrow_forward),
            onPressed: () {
              final center = mapController.camera.center;
              final zoom = mapController.camera.zoom;
              Navigator.of(context).pushReplacement(_createRoute(nextScreen, center, zoom, AxisDirection.left));
            },
          ),
        ],
      ),
    );
  }

  Route _createRoute(Widget Function({required LatLng initialPosition}) screen, LatLng center, double zoom, AxisDirection direction) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => screen(initialPosition: center),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween = Tween(begin: direction == AxisDirection.left ? begin : -begin, end: end).chain(CurveTween(curve: curve));

        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}