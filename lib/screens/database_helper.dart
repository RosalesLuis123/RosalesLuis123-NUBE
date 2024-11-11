import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  // Constructor privado
  DatabaseHelper._internal();

  // Acceso al único objeto DatabaseHelper
  factory DatabaseHelper() => _instance;

  // Obtener la base de datos
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Inicialización de la base de datos y creación de tablas
  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'facturacion.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  // Creación de las tablas en la base de datos
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE Clientes (
    id_cliente INTEGER PRIMARY KEY AUTOINCREMENT,
    nombre TEXT NOT NULL,
    direccion TEXT,
    telefono TEXT,
    email TEXT UNIQUE,
    ci TEXT, -- Añade aquí la columna 'ci'
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      );
    ''');
 // Tabla Empresas
    await db.execute('''
       CREATE TABLE Empresas (
    id_empresa INTEGER PRIMARY KEY AUTOINCREMENT,
    nombre TEXT NOT NULL,
    rubro TEXT,
    NIT TEXT NOT NULL, -- Cambiado RAL a TEXT
    direccion TEXT,
    telefono TEXT,
    email TEXT UNIQUE,
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
  )
    ''');
    await db.execute('''
      CREATE TABLE Productos (
        id_producto INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre TEXT NOT NULL,
        descripcion TEXT,
        precio_unitario REAL NOT NULL,
        stock INTEGER DEFAULT 0,
        categoria TEXT,
        estado TEXT CHECK(estado IN ('activo', 'inactivo')) DEFAULT 'activo'
      );
    ''');

    await db.execute('''
     CREATE TABLE Facturas (
    id_factura INTEGER PRIMARY KEY AUTOINCREMENT,
    numero_factura TEXT NOT NULL,
    id_cliente INTEGER NOT NULL,
    id_empresa INTEGER NOT NULL, -- Asegúrate de que esta línea esté presente
    fecha TEXT NOT NULL,
    total REAL NOT NULL,
    estado TEXT NOT NULL,
    FOREIGN KEY (id_cliente) REFERENCES Clientes(id_cliente),
    FOREIGN KEY (id_empresa) REFERENCES Empresas(id_empresa)
);

    ''');

    await db.execute('''
      CREATE TABLE Detalle_Factura (
        id_detalle INTEGER PRIMARY KEY AUTOINCREMENT,
        id_factura INTEGER,
        id_producto INTEGER,
        cantidad INTEGER NOT NULL,
        precio_unitario REAL NOT NULL,
        subtotal REAL NOT NULL,
        FOREIGN KEY (id_factura) REFERENCES Facturas (id_factura) ON DELETE CASCADE,
        FOREIGN KEY (id_producto) REFERENCES Productos (id_producto) ON DELETE CASCADE
      );
    ''');
await db.execute('''
  CREATE TABLE Ventas (
    id_venta INTEGER PRIMARY KEY AUTOINCREMENT,
    id_factura INTEGER NOT NULL,
    fecha TEXT NOT NULL,
    total REAL NOT NULL,
    FOREIGN KEY (id_factura) REFERENCES Facturas (id_factura) ON DELETE CASCADE
  );
''');

    await db.execute('''
      CREATE TABLE Usuarios (
        id_usuario INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL,
        rol TEXT CHECK(rol IN ('administrador', 'vendedor', 'gerente')) DEFAULT 'vendedor',
        estado TEXT CHECK(estado IN ('activo', 'inactivo')) DEFAULT 'activo'
      );
    ''');

    await db.execute('''
      CREATE TABLE Pagos (
        id_pago INTEGER PRIMARY KEY AUTOINCREMENT,
        id_factura INTEGER,
        fecha_pago DATE DEFAULT CURRENT_DATE,
        monto REAL,
        metodo_pago TEXT CHECK(metodo_pago IN ('efectivo', 'tarjeta', 'transferencia', 'otro')),
        estado TEXT CHECK(estado IN ('completado', 'pendiente', 'anulado')) DEFAULT 'pendiente',
        FOREIGN KEY (id_factura) REFERENCES Facturas (id_factura) ON DELETE CASCADE
      );
    ''');

    await db.execute('''
      CREATE TABLE Categorias_Producto (
        id_categoria INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre TEXT NOT NULL,
        descripcion TEXT
      );
    ''');

    await db.execute('''
      CREATE TABLE Impuestos (
        id_impuesto INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre TEXT NOT NULL,
        porcentaje REAL NOT NULL,
        descripcion TEXT
      );
    ''');
  }
  // Obtener todos los productos de la base de datos
  Future<List<Map<String, dynamic>>> getProductos() async {
    final db = await database;
    return await db.query('Productos'); // Consulta de todos los productos
  }

  // Obtener el total de stock de productos activos
  Future<int> getTotalStock() async {
    final db = await database;
    var result = await db.rawQuery('SELECT SUM(stock) FROM Productos WHERE estado = "activo"');
    return result.isNotEmpty ? result.first.values.first as int : 0;
  }

  // Obtener productos activos por estado
  Future<List<Map<String, dynamic>>> getProductosActivos() async {
    final db = await database;
    return await db.query('Productos', where: 'estado = ?', whereArgs: ['activo']);
  }

  // Obtener productos inactivos
  Future<List<Map<String, dynamic>>> getProductosInactivos() async {
    final db = await database;
    return await db.query('Productos', where: 'estado = ?', whereArgs: ['inactivo']);
  }

  // Obtener los precios de los productos
  Future<List<Map<String, dynamic>>> getPreciosProductos() async {
    final db = await database;
    return await db.query('Productos', columns: ['nombre', 'precio_unitario']);
  }
}
