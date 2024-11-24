import 'package:jean_jean/presentation/business_logic/models/aaction.dart';
import 'package:jean_jean/presentation/business_logic/services/lvao_api.dart';

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
    );
  }

  static Future<List<Acteur>> getActeurList(
    double latitude, double longitude, List<int>? actionIds) async {

    List apiResponse = await ApiService().getActeurList(latitude, longitude, actionIds);

    final acteurList = apiResponse
          .map<Acteur>((item) => Acteur.fromJson(item))
          .toList();

    // Dédupliquer les items selon la clé identifiant_unique
    final uniqueActeurs = <String, Acteur>{};
    for (var acteur in acteurList) {
      uniqueActeurs[acteur.identifiantUnique] = acteur;
    }

    return uniqueActeurs.values.toList();
  }
}
