class Inventario {
  final int? id;
  final int idEmpresa;
  final String nombreProducto;
  final int cantidadDisponible;
  final double precioUnitario;

  Inventario({
    this.id,
    required this.idEmpresa,
    required this.nombreProducto,
    required this.cantidadDisponible,
    required this.precioUnitario,
  });

  Map<String, dynamic> toMap() {
    return {
      'id_empresa': idEmpresa,
      'nombre_producto': nombreProducto,
      'cantidad_disponible': cantidadDisponible,
      'precio_unitario': precioUnitario,
    };
  }

  static Inventario fromMap(Map<String, dynamic> map) {
    return Inventario(
      id: map['id_item'],
      idEmpresa: map['id_empresa'],
      nombreProducto: map['nombre_producto'],
      cantidadDisponible: map['cantidad_disponible'],
      precioUnitario: map['precio_unitario'],
    );
  }
}
