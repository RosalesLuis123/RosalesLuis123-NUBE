import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;

  DatabaseService._internal();
  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'empresa_IA1.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
         // Tabla Personas
    await db.execute('''
      CREATE TABLE Personas (
        id_persona INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        telefono TEXT,
        direccion TEXT,
        fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        tipo_persona TEXT NOT NULL CHECK (tipo_persona IN ('usuario', 'cliente', 'empleado'))
      )
    ''');

    // Tabla Usuarios
    await db.execute('''
      CREATE TABLE Usuarios (
        id_usuario INTEGER PRIMARY KEY AUTOINCREMENT,
        id_persona INTEGER NOT NULL,
        password_hash TEXT,
        rol TEXT NOT NULL CHECK (rol IN ('administrador', 'empresario', 'empleado')),
        fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        ultimo_acceso TIMESTAMP,
        activo INTEGER DEFAULT 1,  -- 1 = true, 0 = false
        id_plan INTEGER,
        firebase_uid TEXT,
        firebase_token TEXT,
        FOREIGN KEY (id_persona) REFERENCES Personas(id_persona),
        FOREIGN KEY (id_plan) REFERENCES Planes(id_plan)
      )
    ''');

    // Tabla Planes
    await db.execute('''
      CREATE TABLE Planes (
        id_plan INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre_plan TEXT NOT NULL,
        precio_mensual REAL,
        limite_usuarios INTEGER,
        limite_inventario INTEGER,
        descripcion TEXT,
        fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    // Tabla Empresas
    await db.execute('''
      CREATE TABLE Empresas (
        id_empresa INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre TEXT NOT NULL,
        id_usuario INTEGER NOT NULL,
        rubro TEXT,
        direccion TEXT,
        telefono TEXT,
        email TEXT UNIQUE,
        fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        id_plan INTEGER,
        FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario),
        FOREIGN KEY (id_plan) REFERENCES Planes(id_plan)
      )
    ''');

    // Tabla Clientes
    await db.execute('''
      CREATE TABLE Clientes (
        id_cliente INTEGER PRIMARY KEY AUTOINCREMENT,
        id_persona INTEGER NOT NULL,
        id_empresa INTEGER NOT NULL,
        FOREIGN KEY (id_persona) REFERENCES Personas(id_persona),
        FOREIGN KEY (id_empresa) REFERENCES Empresas(id_empresa)
      )
    ''');

    // Tabla Empleados
    await db.execute('''
      CREATE TABLE Empleados (
        id_empleado INTEGER PRIMARY KEY AUTOINCREMENT,
        id_persona INTEGER NOT NULL,
        id_empresa INTEGER NOT NULL,
        cargo TEXT,
        salario REAL,
        fecha_contratacion DATE,
        FOREIGN KEY (id_persona) REFERENCES Personas(id_persona),
        FOREIGN KEY (id_empresa) REFERENCES Empresas(id_empresa)
      )
    ''');

    // Tabla Estadisticas_Ventas
    await db.execute('''
      CREATE TABLE Estadisticas_Ventas (
        id_venta INTEGER PRIMARY KEY AUTOINCREMENT,
        id_empresa INTEGER NOT NULL,
        fecha_venta DATE,
        monto_total REAL,
        cantidad_items INTEGER,
        metodo_pago TEXT CHECK (metodo_pago IN ('efectivo', 'tarjeta', 'transferencia')),
        FOREIGN KEY (id_empresa) REFERENCES Empresas(id_empresa)
      )
    ''');

    // Tabla Inventarios
    await db.execute('''
      CREATE TABLE Inventarios (
        id_item INTEGER PRIMARY KEY AUTOINCREMENT,
        id_empresa INTEGER NOT NULL,
        nombre_producto TEXT NOT NULL,
        cantidad_disponible INTEGER,
        precio_unitario REAL,
        fecha_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (id_empresa) REFERENCES Empresas(id_empresa)
      )
    ''');

    // Tabla Pronosticos_Financieros
    await db.execute('''
      CREATE TABLE Pronosticos_Financieros (
        id_pronostico INTEGER PRIMARY KEY AUTOINCREMENT,
        id_empresa INTEGER NOT NULL,
        fecha_inicio DATE,
        fecha_fin DATE,
        pronostico_ventas REAL,
        pronostico_inventario INTEGER,
        fecha_generacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (id_empresa) REFERENCES Empresas(id_empresa)
      )
    ''');

    // Tabla Pagos
    await db.execute('''
      CREATE TABLE Pagos (
        id_pago INTEGER PRIMARY KEY AUTOINCREMENT,
        id_empresa INTEGER NOT NULL,
        id_plan INTEGER NOT NULL,
        monto_pago REAL,
        fecha_pago TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        metodo_pago TEXT CHECK (metodo_pago IN ('tarjeta', 'transferencia', 'paypal')),
        estado_pago TEXT CHECK (estado_pago IN ('completado', 'pendiente', 'fallido')),
        FOREIGN KEY (id_empresa) REFERENCES Empresas(id_empresa),
        FOREIGN KEY (id_plan) REFERENCES Planes(id_plan)
      )
    ''');

    // Tabla Facturas
    await db.execute('''
  CREATE TABLE Facturas (
    id_factura INTEGER PRIMARY KEY AUTOINCREMENT,
    id_empresa INTEGER NOT NULL,
    id_cliente INTEGER NOT NULL,
    fecha_factura DATE DEFAULT CURRENT_TIMESTAMP,
    metodo_pago TEXT CHECK (metodo_pago IN ('efectivo', 'tarjeta', 'transferencia', 'paypal')),
    estado TEXT CHECK (estado IN ('pagada', 'pendiente', 'cancelada')),
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_empresa) REFERENCES Empresas(id_empresa),
    FOREIGN KEY (id_cliente) REFERENCES Clientes(id_cliente)
  )
''');
await db.execute('''
  CREATE TABLE Detalles_Factura (
    id_detalle INTEGER PRIMARY KEY AUTOINCREMENT,
    id_factura INTEGER NOT NULL,
    id_item INTEGER NOT NULL,
    cantidad INTEGER NOT NULL,
    precio_unitario REAL NOT NULL,
    subtotal REAL NOT NULL,  -- Para almacenar la cantidad * precio_unitario
    FOREIGN KEY (id_factura) REFERENCES Facturas(id_factura),
    FOREIGN KEY (id_item) REFERENCES Inventarios(id_item)
  )
''');


    // Tabla Proveedores
    await db.execute('''
      CREATE TABLE Proveedores (
        id_proveedor INTEGER PRIMARY KEY AUTOINCREMENT,
        id_empresa INTEGER NOT NULL,
        nombre_proveedor TEXT NOT NULL,
        email_proveedor TEXT,
        telefono_proveedor TEXT,
        direccion_proveedor TEXT,
        fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (id_empresa) REFERENCES Empresas(id_empresa)
      )
    ''');

    // Tabla Ordenes_Compra
    await db.execute('''
      CREATE TABLE Ordenes_Compra (
        id_orden INTEGER PRIMARY KEY AUTOINCREMENT,
        id_empresa INTEGER NOT NULL,
        id_proveedor INTEGER NOT NULL,
        fecha_orden DATE,
        monto_total REAL,
        estado_orden TEXT CHECK (estado_orden IN ('pendiente', 'enviada', 'recibida')),
        FOREIGN KEY (id_empresa) REFERENCES Empresas(id_empresa),
        FOREIGN KEY (id_proveedor) REFERENCES Proveedores(id_proveedor)
      )
    ''');

    // Tabla Descuentos
    await db.execute('''
      CREATE TABLE Descuentos (
        id_descuento INTEGER PRIMARY KEY AUTOINCREMENT,
        id_empresa INTEGER NOT NULL,
        descripcion TEXT,
        porcentaje REAL,
        fecha_inicio DATE,
        fecha_fin DATE,
        FOREIGN KEY (id_empresa) REFERENCES Empresas(id_empresa)
      )
    ''');

    // Tabla Soporte
    await db.execute('''
      CREATE TABLE Soporte (
        id_soporte INTEGER PRIMARY KEY AUTOINCREMENT,
        id_usuario INTEGER NOT NULL,
        tipo_solicitud TEXT CHECK (tipo_solicitud IN ('técnico', 'financiero', 'otro')),
        descripcion TEXT,
        fecha_solicitud TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        estado TEXT CHECK (estado IN ('pendiente', 'en proceso', 'resuelto')),
        FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario)
      )
    ''');

    // Tabla Auditorias
    await db.execute('''
      CREATE TABLE Auditorias (
        id_auditoria INTEGER PRIMARY KEY AUTOINCREMENT,
        id_usuario INTEGER NOT NULL,
        accion TEXT,
        fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        direccion_ip TEXT,
        FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario)
      )
    ''');
      },
    );
  }

  // CRUD para Empleados
  Future<int> createEmpleado(Map<String, dynamic> empleado) async {
    final db = await database;
    return db.insert('Empleados', empleado);
  }

  Future<List<Map<String, dynamic>>> readEmpleados() async {
    final db = await database;
    return db.query('Empleados');
  }

  Future<int> updateEmpleado(int id, Map<String, dynamic> empleado) async {
    final db = await database;
    return db.update('Empleados', empleado, where: 'id_empleado = ?', whereArgs: [id]);
  }

  Future<int> deleteEmpleado(int id) async {
    final db = await database;
    return db.delete('Empleados', where: 'id_empleado = ?', whereArgs: [id]);
  }

  // CRUD para Personas
  Future<int> createPersona(Map<String, dynamic> persona) async {
    final db = await database;
    return db.insert('Personas', persona);
  }

  Future<List<Map<String, dynamic>>> readPersonas() async {
    final db = await database;
    return db.query('Personas');
  }

  Future<int> updatePersona(int id, Map<String, dynamic> persona) async {
    final db = await database;
    return db.update('Personas', persona, where: 'id_persona = ?', whereArgs: [id]);
  }

  Future<int> deletePersona(int id) async {
    final db = await database;
    return db.delete('Personas', where: 'id_persona = ?', whereArgs: [id]);
  }

  Future<int> createFactura(Map<String, dynamic> factura) async {
  final db = await database;
  return db.insert('Facturas', factura);
}

// También puedes crear un método para leer facturas si es necesario
Future<List<Map<String, dynamic>>> readFacturas() async {
  final db = await database;
  return db.query('Facturas');
}
// Método para crear un detalle de factura
Future<int> createDetalleFactura(Map<String, dynamic> detalleFactura) async {
  final db = await database;
  return db.insert('Detalles_Factura', detalleFactura);
}

// También puedes crear un método para leer detalles de facturas si es necesario
Future<List<Map<String, dynamic>>> readDetallesFactura(int idFactura) async {
  final db = await database;
  return db.query('Detalles_Factura', where: 'id_factura = ?', whereArgs: [idFactura]);
}
// Método para obtener todos los clientes
Future<List<Map<String, dynamic>>> getClientes() async {
  final db = await database;
  return db.query('Clientes');
}

Future<List<Map<String, dynamic>>> getProductos() async {
  final db = await database;
  return db.query('Inventarios'); // Asegúrate de que 'Inventarios' tiene los datos necesarios (nombre, precio)
}

// Método para crear un nuevo inventario
Future<int> createInventario(Map<String, dynamic> inventario) async {
  final db = await database;
  return db.insert('Inventarios', inventario);
}

// Método para actualizar un inventario
Future<int> updateInventario(int id, Map<String, dynamic> inventario) async {
  final db = await database;
  return db.update('Inventarios', inventario, where: 'id_item = ?', whereArgs: [id]);
}

// Método para eliminar un inventario
Future<int> deleteInventario(int id) async {
  final db = await database;
  return db.delete('Inventarios', where: 'id_item = ?', whereArgs: [id]);
}
Future<List<Map<String, dynamic>>> readInventarios() async {
  final db = await database;
  return db.query('Inventarios');
}

}
