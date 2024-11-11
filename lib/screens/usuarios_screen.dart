import 'package:flutter/material.dart';
import '../widgets/app_header.dart';

class UsuariosScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppHeader(),
      body: Center(child: Text("Gestión de Usuarios")),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Agregar lógica para añadir usuario
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
