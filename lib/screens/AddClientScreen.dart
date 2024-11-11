import 'package:flutter/material.dart';
import 'database_helper.dart'; // Importa DatabaseService

class AddClientScreen extends StatelessWidget {
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController direccionController = TextEditingController();
  final TextEditingController telefonoController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController ciController = TextEditingController(); // Campo para C.I.

  // Guardar cliente en la base de datos
  Future<void> _guardarCliente(BuildContext context) async {
    final db = await DatabaseHelper().database;
    int clientId = await db.insert('Clientes', {
      'nombre': nombreController.text,
      'direccion': direccionController.text,
      'telefono': telefonoController.text,
      'email': emailController.text,
      'ci': ciController.text, // Guardar C.I.
      'fecha_registro': DateTime.now().toIso8601String(),
    });
    Navigator.pop(context, clientId); // Retorna el id del nuevo cliente
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Agregar Cliente')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: nombreController, decoration: InputDecoration(labelText: 'Nombre')),
            TextField(controller: direccionController, decoration: InputDecoration(labelText: 'Dirección')),
            TextField(controller: telefonoController, decoration: InputDecoration(labelText: 'Teléfono')),
            TextField(controller: emailController, decoration: InputDecoration(labelText: 'Email')),
            TextField(controller: ciController, decoration: InputDecoration(labelText: 'C.I.')), // Campo para C.I.
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _guardarCliente(context),
              child: Text('Guardar Cliente'),
            ),
          ],
        ),
      ),
    );
  }
}
