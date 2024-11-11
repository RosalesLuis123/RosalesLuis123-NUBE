import 'package:flutter/material.dart';

class ClientsChartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gráfico de Clientes'),
      ),
      body: Center(
        child: Text(
          'Cliente',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
