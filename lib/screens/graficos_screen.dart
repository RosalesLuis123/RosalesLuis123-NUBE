import 'package:flutter/material.dart';
import '../widgets/app_header.dart';
import 'sales_chart_screen.dart'; // Pantalla de gráficos de ventas
import 'clients_chart_screen.dart'; // Pantalla de gráficos de clientes
import 'inventory_chart_screen.dart'; // Pantalla de gráficos de inventario

class GraficosScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppHeader(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SalesChartScreen()),
                );
              },
              child: Text('Graf Venta'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50), // Botón de ancho completo
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ClientsChartScreen()),
                );
              },
              child: Text('Graf Clientes'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50), // Botón de ancho completo
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => InventoryChartScreen()),
                );
              },
              child: Text('Graf Inventario'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50), // Botón de ancho completo
              ),
            ),
          ],
        ),
      ),
    );
  }
}
