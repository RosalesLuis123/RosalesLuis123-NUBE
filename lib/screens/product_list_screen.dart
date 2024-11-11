import 'package:flutter/material.dart';
import 'database_helper.dart'; // Importa DatabaseHelper

class ProductListScreen extends StatefulWidget {
  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  List<Map<String, dynamic>> productos = [];
  int? idProductoSeleccionado; // Almacena solo el ID del producto seleccionado
  int cantidad = 1;
  double subtotal = 0.0;

  @override
  void initState() {
    super.initState();
    _loadProductos();
  }

  // Cargar productos desde la base de datos
  Future<void> _loadProductos() async {
    final db = await DatabaseHelper().database;
    final productosList = await db.query('Productos');
    setState(() {
      productos = productosList;
    });
  }

  // Calcular el subtotal
  void _calcularSubtotal() {
    if (idProductoSeleccionado != null) {
      // Encuentra el producto seleccionado
      final producto = productos.firstWhere((p) => p['id_producto'] == idProductoSeleccionado);
      subtotal = producto['precio_unitario'] * cantidad;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Seleccionar Producto')),
      body: Column(
        children: [
          DropdownButton<int>(
            hint: Text('Selecciona un producto'),
            value: idProductoSeleccionado,
            onChanged: (newValue) {
              setState(() {
                idProductoSeleccionado = newValue; // Solo almacenamos el ID
                _calcularSubtotal();
              });
            },
            items: productos.map((producto) {
              return DropdownMenuItem<int>(
                value: producto['id_producto'], // Solo pasamos el ID aquí
                child: Text(producto['nombre']),
              );
            }).toList(),
          ),
          TextField(
            decoration: InputDecoration(labelText: 'Cantidad'),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              setState(() {
                cantidad = int.tryParse(value) ?? 1;
                _calcularSubtotal();
              });
            },
          ),
          Text('Subtotal: \$${subtotal.toStringAsFixed(2)}'),
          ElevatedButton(
            onPressed: () {
              if (idProductoSeleccionado != null) {
                // Encuentra el producto completo
                final producto = productos.firstWhere((p) => p['id_producto'] == idProductoSeleccionado);
                Navigator.pop(context, {
                  'id_producto': producto['id_producto'],
                  'nombre': producto['nombre'],
                  'cantidad': cantidad,
                  'precio_unitario': producto['precio_unitario'],
                  'subtotal': subtotal,
                });
              }
            },
            child: Text('Agregar a la Factura'),
          ),
        ],
      ),
    );
  }
}
