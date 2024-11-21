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
