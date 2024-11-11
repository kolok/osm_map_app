class AAction {
  final String border;
  final String background;
  final int id;
  final String code;
  final String libelle;
  final String icon;
  final String couleur;

  AAction({
    required this.border,
    required this.background,
    required this.id,
    required this.code,
    required this.libelle,
    required this.icon,
    required this.couleur,
  });

  factory AAction.fromJson(Map<String, dynamic> json) {
    return AAction(
      border: json['border'],
      background: json['background'],
      id: json['id'],
      code: json['code'],
      libelle: json['libelle'],
      icon: json['icon'],
      couleur: json['couleur'],
    );
  }
}

class Acteur {
  final String identifiantUnique;
  final double latitude;
  final double longitude;
  final String nom;
  final List<AAction> actions;

  Acteur({
    required this.identifiantUnique,
    required this.latitude,
    required this.longitude,
    required this.nom,
    required this.actions,
  });

  factory Acteur.fromJson(Map<String, dynamic> json) {
    return Acteur(
      identifiantUnique: json['identifiant_unique'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      nom: json['nom'],
      actions: (json['actions'] as List).map((action) => AAction.fromJson(action)).toList(),
//      actions: (json['actions'] as List).map((action) => action['id'] as int).toList(),
    );
  }
}
