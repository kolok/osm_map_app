class AAction {
  final int id;
  final String code;
  final String libelle;

  AAction({
    required this.id,
    required this.code,
    required this.libelle,
  });

  factory AAction.fromJson(Map<String, dynamic> json) {
    return AAction(
      id: json['id'],
      code: json['code'],
      libelle: json['libelle'],
    );
  }
}

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
      actions: (json['actions'] as List).map((action) => AAction.fromJson(action)).toList(),
//      actions: (json['actions'] as List).map((action) => action['id'] as int).toList(),
    );
  }
}
