import 'package:flutter/material.dart';
import 'package:jean_jean/presentation/business_logic/models/aaction.dart';
import 'package:jean_jean/presentation/business_logic/models/acteur.dart';
import 'package:jean_jean/presentation/pages/add_actor_form.dart';
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
            // Autres champs
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  final actorData = {
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