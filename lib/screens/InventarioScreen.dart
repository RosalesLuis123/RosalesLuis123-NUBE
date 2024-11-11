import 'package:flutter/material.dart';
import 'database_helper.dart';

class InventarioScreen extends StatefulWidget {
  @override
  _InventarioScreenState createState() => _InventarioScreenState();
}

class _InventarioScreenState extends State<InventarioScreen> {
  List<Map<String, dynamic>> productos = [];
  final sqlController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProductos();
  }

  Future<void> _loadProductos() async {
    final db = await DatabaseHelper().database;
    final List<Map<String, dynamic>> listaProductos = await db.query('Productos');
    setState(() {
      productos = listaProductos;
    });
  }

  Future<void> _showDialog({Map<String, dynamic>? producto}) async {
    final nombreController = TextEditingController(text: producto?['nombre']);
    final descripcionController = TextEditingController(text: producto?['descripcion']);
    final precioController = TextEditingController(text: producto?['precio_unitario']?.toString());
    final stockController = TextEditingController(text: producto?['stock']?.toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(producto == null ? 'Añadir Producto' : 'Editar Producto'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTextField(nombreController, 'Nombre'),
                _buildTextField(descripcionController, 'Descripción'),
                _buildTextField(precioController, 'Precio Unitario', TextInputType.number),
                _buildTextField(stockController, 'Stock', TextInputType.number),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                if (producto == null) {
                  await _addProducto(
                    nombreController.text,
                    descripcionController.text,
                    double.tryParse(precioController.text) ?? 0.0,
                    int.tryParse(stockController.text) ?? 0,
                  );
                } else {
                  await _updateProducto(
                    producto['id_producto'],
                    nombreController.text,
                    descripcionController.text,
                    double.tryParse(precioController.text) ?? 0.0,
                    int.tryParse(stockController.text) ?? 0,
                  );
                }
                Navigator.of(context).pop();
              },
              child: Text(producto == null ? 'Añadir' : 'Guardar'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, [TextInputType keyboardType = TextInputType.text]) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          filled: true,
          fillColor: Colors.grey[200],
        ),
        keyboardType: keyboardType,
      ),
    );
  }

  Future<void> _addProducto(String nombre, String descripcion, double precio, int stock) async {
    final db = await DatabaseHelper().database;
    await db.insert('Productos', {
      'nombre': nombre,
      'descripcion': descripcion,
      'precio_unitario': precio,
      'stock': stock,
      'estado': 'activo',
    });
    _loadProductos();
  }

  Future<void> _updateProducto(int id, String nombre, String descripcion, double precio, int stock) async {
    final db = await DatabaseHelper().database;
    await db.update(
      'Productos',
      {
        'nombre': nombre,
        'descripcion': descripcion,
        'precio_unitario': precio,
        'stock': stock,
      },
      where: 'id_producto = ?',
      whereArgs: [id],
    );
    _loadProductos();
  }

  Future<void> _deleteProducto(int id) async {
    final db = await DatabaseHelper().database;
    await db.delete('Productos', where: 'id_producto = ?', whereArgs: [id]);
    _loadProductos();
  }

  Future<void> _executeSQL() async {
    final sql = sqlController.text;

    if (sql.isNotEmpty) {
      final db = await DatabaseHelper().database;
      try {
        await db.execute(sql);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Consulta ejecutada con éxito.')),
        );
        _loadProductos();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al ejecutar la consulta: $e')),
        );
      }
      sqlController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, introduce una consulta SQL.')),
      );
    }
  }

  void _showDeleteConfirmationDialog(int id) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Eliminar Producto'),
          content: Text('¿Estás seguro de que quieres eliminar este producto?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                _deleteProducto(id);
                Navigator.of(context).pop();
              },
              child: Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inventario'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _showDialog(),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Ejecutar Consulta SQL', style: TextStyle(fontSize: 18)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: TextField(
              controller: sqlController,
              decoration: InputDecoration(
                labelText: 'Ingrese su consulta SQL aquí',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.grey[200],
              ),
              maxLines: 3,
            ),
          ),
          ElevatedButton(
            onPressed: _executeSQL,
            child: Text('Ejecutar Consulta'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: productos.length,
              itemBuilder: (context, index) {
                final producto = productos[index];
                return Card(
                  margin: EdgeInsets.all(8.0),
                  elevation: 2,
                  child: ListTile(
                    title: Text(producto['nombre'], style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('Precio: \$${producto['precio_unitario']}, Stock: ${producto['stock']}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _showDialog(producto: producto),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _showDeleteConfirmationDialog(producto['id_producto']),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
