import 'package:flutter/material.dart';
import '../widgets/app_header.dart';

class EmpresasScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppHeader(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _buildButton(
                context,
                'Facturación',
                Icons.receipt, // Icono para facturación
                '/facturacion',
              ),
              SizedBox(height: 20),
              _buildButton(
                context,
                'Gestión de Empresas',
                Icons.business, // Icono para gestión de empresas
                '/gestion_empresas',
              ),
              SizedBox(height: 20),
              _buildButton(
                context,
                'Ventas',
                Icons.sell, // Icono para ventas
                '/ventas',
              ),
              SizedBox(height: 20),
              _buildButton(
                context,
                'Inventarios',
                Icons.inventory, // Icono para inventarios
                '/inventarios',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context, String label, IconData icon, String route) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () {
          Navigator.pushNamed(context, route);
        },
        child: Container(
          padding: EdgeInsets.all(16),
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                icon,
                size: 40, // Ajusta el tamaño del ícono
                color: Theme.of(context).primaryColor, // Cambia el color según tu tema
              ),
              SizedBox(width: 20), // Espaciado entre ícono y texto
              Text(
                label,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
