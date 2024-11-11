class Persona {
  int? id;
  String nombre;
  String email;
  String telefono;
  String direccion;
  DateTime fechaRegistro;
  String tipoPersona;

  Persona({
    this.id,
    required this.nombre,
    required this.email,
    required this.telefono,
    required this.direccion,
    required this.fechaRegistro,
    required this.tipoPersona,
  });

  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'email': email,
      'telefono': telefono,
      'direccion': direccion,
      'fecha_registro': fechaRegistro.toIso8601String(),
      'tipo_persona': tipoPersona,
    };
  }

  factory Persona.fromMap(Map<String, dynamic> map) {
    return Persona(
      id: map['id_persona'],
      nombre: map['nombre'],
      email: map['email'],
      telefono: map['telefono'],
      direccion: map['direccion'],
      fechaRegistro: DateTime.parse(map['fecha_registro']),
      tipoPersona: map['tipo_persona'],
    );
  }
}
