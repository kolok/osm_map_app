import 'package:jean_jean/presentation/business_logic/models/aaction.dart';

class Acteur {
  final String identifiantUnique;
  final double latitude;
  final double longitude;
  final String nom;
  final String? nomCommercial;
  final String? adresse;
  final String? siret;
  final List<AAction> actions;

  Acteur({
    required this.identifiantUnique,
    required this.latitude,
    required this.longitude,
    required this.nom,
    required this.actions,
    this.nomCommercial,
    this.adresse,
    this.siret,
  });

  factory Acteur.fromJson(Map<String, dynamic> json) {
    return Acteur(
      identifiantUnique: json['identifiant_unique'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      nom: json['nom'],
      nomCommercial: json['nom_commercial'],
      adresse: json['adresse'],
      siret: json['siret'],
      actions: 
      (json['actions'] as List).map((action) => 
        // Todo: récupérer ça d'un cache plutôt que de faire un nouvel objet
        AAction.fromJson(action)
      ).toList(),
//      actions: (json['actions'] as List).map((action) => action['id'] as int).toList(),
    );
  }
}
