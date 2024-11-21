import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class AddActorForm extends StatefulWidget {
  final LatLng position;

  const AddActorForm({super.key, required this.position});

  @override
  AddActorFormState createState() => AddActorFormState();
}

class AddActorFormState extends State<AddActorForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Proposer un nouvel acteur'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Nom de l\'acteur'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un nom';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer une description';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Ajoutez ici la logique pour proposer un nouvel acteur
                    Navigator.of(context).pop({
                      'nom': _nameController.text,
                      'description': _descriptionController.text,
                      'position': widget.position,
                    });
                  }
                },
                child: Text('Proposer'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}