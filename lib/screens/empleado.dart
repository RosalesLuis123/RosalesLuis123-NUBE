class Empleado {
  int? id;
  int idPersona;
  int idEmpresa;
  String cargo;  // Hacer mutable
  double salario;
  DateTime fechaContratacion;

  Empleado({
    this.id,
    required this.idPersona,
    required this.idEmpresa,
    required this.cargo,
    required this.salario,
    required this.fechaContratacion,
  });

  Map<String, dynamic> toMap() {
    return {
      'id_persona': idPersona,
      'id_empresa': idEmpresa,
      'cargo': cargo,
      'salario': salario,
      'fecha_contratacion': fechaContratacion.toIso8601String(),
    };
  }

  factory Empleado.fromMap(Map<String, dynamic> map) {
    return Empleado(
      id: map['id_empleado'],
      idPersona: map['id_persona'],
      idEmpresa: map['id_empresa'],
      cargo: map['cargo'],
      salario: map['salario'],
      fechaContratacion: DateTime.parse(map['fecha_contratacion']),
    );
  }
}
