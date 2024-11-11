import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'database_helper.dart'; // Importa DatabaseHelper

class VentasScreen extends StatefulWidget {
  @override
  _VentasScreenState createState() => _VentasScreenState();
}

class _VentasScreenState extends State<VentasScreen> {
  List<Map<String, dynamic>> _ventas = [];
  bool _ordenAscendente = true;
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargarVentas();
  }

  Future<void> _cargarVentas() async {
    final Database db = await DatabaseHelper().database;
    List<Map<String, dynamic>> ventas = await db.query('Ventas');
    setState(() {
      _ventas = ventas;
      _cargando = false; // Cambiar estado de carga a false
    });
  }

  void _ordenarVentas(String criterio) {
    setState(() {
      if (criterio == 'fecha') {
        _ventas.sort((a, b) => _ordenAscendente
            ? a['fecha'].compareTo(b['fecha'])
            : b['fecha'].compareTo(a['fecha']));
      } else if (criterio == 'cantidad') {
        _ventas.sort((a, b) => _ordenAscendente
            ? a['cantidad'].compareTo(b['cantidad'])
            : b['cantidad'].compareTo(a['cantidad']));
      } else if (criterio == 'precio') {
        _ventas.sort((a, b) => _ordenAscendente
            ? a['total'].compareTo(b['total'])
            : b['total'].compareTo(a['total']));
      }
      _ordenAscendente = !_ordenAscendente;
    });
  }

  void _editarVenta(Map<String, dynamic> venta) {
    // Aquí deberías implementar la lógica para editar la venta
    // Por ejemplo, abrir un diálogo o una nueva pantalla para editar
    // En este ejemplo, solo se mostrará un mensaje con los datos de la venta
    showDialog(
      context: context,
      builder: (context) {
        TextEditingController cantidadController = TextEditingController(text: venta['cantidad'].toString());
        TextEditingController totalController = TextEditingController(text: venta['total'].toString());

        return AlertDialog(
          title: Text('Editar Venta ID: ${venta['id_venta']}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: cantidadController,
                decoration: InputDecoration(labelText: 'Cantidad'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: totalController,
                decoration: InputDecoration(labelText: 'Total'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Actualizar la venta en la base de datos
                int cantidad = int.tryParse(cantidadController.text) ?? 0;
                double total = double.tryParse(totalController.text) ?? 0.0;

                // Aquí deberías implementar la lógica para actualizar la venta en la base de datos
                // Por ejemplo: await DatabaseHelper().updateVenta(venta['id_venta'], cantidad, total);
                
                // Actualizar la lista local
                setState(() {
                  venta['cantidad'] = cantidad;
                  venta['total'] = total;
                });
                Navigator.of(context).pop();
              },
              child: Text('Guardar'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancelar'),
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
        title: Text('Lista de Ventas', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          PopupMenuButton<String>(
            onSelected: _ordenarVentas,
            itemBuilder: (BuildContext context) {
              return {'fecha', 'cantidad', 'precio'}.map((String criterio) {
                return PopupMenuItem<String>(
                  value: criterio,
                  child: Row(
                    children: [
                      Icon(Icons.sort), // Icono para ordenar
                      SizedBox(width: 8),
                      Text('Ordenar por $criterio'),
                    ],
                  ),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: _cargando
          ? Center(child: CircularProgressIndicator()) // Indicador de carga
          : ListView.builder(
              itemCount: _ventas.length,
              itemBuilder: (context, index) {
                final venta = _ventas[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16),
                    title: Text('Venta ID: ${venta['id_venta']}', style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Fecha: ${venta['fecha']}', style: TextStyle(color: Colors.grey[600])),
                        SizedBox(height: 4),
                        Text('Cantidad: ${venta['cantidad']}', style: TextStyle(color: Colors.grey[600])),
                        SizedBox(height: 4),
                        Text('Total: \$${venta['total'].toStringAsFixed(2)}', style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => _editarVenta(venta),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
