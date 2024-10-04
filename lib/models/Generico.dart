class Generico {
  Generico({
    required this.descripcion,
    required this.codigo,
  });

  String descripcion;
  String codigo;

  factory Generico.fromJson(Map<String, dynamic> json) => Generico(
        descripcion: json["descripcion"],
        codigo: json["codigo"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "descripcion": descripcion,
        "codigo": codigo,
      };
}
