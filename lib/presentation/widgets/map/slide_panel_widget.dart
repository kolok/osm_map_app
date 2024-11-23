import 'package:flutter/material.dart';

class SlidePanelWidget extends StatelessWidget {
  final String selectedActorName;
  final VoidCallback onClose;

  const SlidePanelWidget({
    super.key,
    required this.selectedActorName,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          IconButton(
            icon: Icon(Icons.close),
            onPressed: onClose,
          ),
          Text(
            selectedActorName,
            style: TextStyle(fontSize: 24),
          ),
        ],
      ),
    );
  }
}