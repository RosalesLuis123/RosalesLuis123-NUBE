import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'database_helper.dart';

class InventoryChartScreen extends StatefulWidget {
  @override
  _InventoryChartScreenState createState() => _InventoryChartScreenState();
}

class _InventoryChartScreenState extends State<InventoryChartScreen> {
  late List<Map<String, dynamic>> _productos = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  // Cargar productos desde la base de datos
  Future<void> _loadProducts() async {
    final db = await DatabaseHelper().database;
    final products = await db.query('Productos');
    setState(() {
      _productos = products;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gráficos de Inventario'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView( // Hacer la página deslizable
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Gráfico de barras de precios
                    SizedBox(
                      height: 250,
                      child: BarChart(
                        BarChartData(
                          barGroups: _getPriceBarGroups(),
                          titlesData: FlTitlesData(
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  return Text(_productos[value.toInt()]['nombre']);
                                },
                              ),
                            ),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: true),
                            ),
                            topTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            rightTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                          ),
                          borderData: FlBorderData(show: true),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    // Gráfico de pastel del stock
                    SizedBox(
                      height: 250,
                      child: PieChart(
                        PieChartData(
                          sections: _getStockPieSections(),
                          borderData: FlBorderData(show: false),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    // Gráfico de líneas para comparar stock
                    SizedBox(
                      height: 250,
                      child: LineChart(
                        LineChartData(
                          lineBarsData: [
                            LineChartBarData(
                              spots: _getStockLineData(),
                              isCurved: true,
                              color: Colors.green, // Cambiar a color en lugar de colors
                              belowBarData: BarAreaData(show: true, color: Colors.green.withOpacity(0.3)),
                              dotData: FlDotData(show: true),
                            ),
                          ],
                          titlesData: FlTitlesData(
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  return Text(_productos[value.toInt()]['nombre']);
                                },
                              ),
                            ),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: true),
                            ),
                            topTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            rightTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                          ),
                          borderData: FlBorderData(show: true),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    // Gráfico de líneas para comparar precios unitarios
                    SizedBox(
                      height: 250,
                      child: LineChart(
                        LineChartData(
                          lineBarsData: [
                            LineChartBarData(
                              spots: _getPriceLineData(),
                              isCurved: true,
                              color: Colors.blue, // Cambiar a color en lugar de colors
                              belowBarData: BarAreaData(show: true, color: Colors.blue.withOpacity(0.3)),
                              dotData: FlDotData(show: true),
                            ),
                          ],
                          titlesData: FlTitlesData(
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  return Text(_productos[value.toInt()]['nombre']);
                                },
                              ),
                            ),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: true),
                            ),
                            topTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            rightTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                          ),
                          borderData: FlBorderData(show: true),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  // Generar datos para el gráfico de barras de precios
  List<BarChartGroupData> _getPriceBarGroups() {
    return List.generate(_productos.length, (index) {
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: (_productos[index]['precio_unitario'] as num).toDouble(), // Convertir a double
            color: (_productos[index]['estado'] == 'activo') ? Colors.blue : Colors.grey,
            width: 22,
            borderRadius: BorderRadius.circular(5),
          ),
        ],
      );
    });
  }

  // Generar secciones para el gráfico de pastel del stock
  List<PieChartSectionData> _getStockPieSections() {
    int activeStock = _productos
        .where((p) => p['estado'] == 'activo')
        .fold(0, (sum, p) => sum + (p['stock'] as int)); // Asegurar que es int
    int inactiveStock = _productos
        .where((p) => p['estado'] == 'inactivo')
        .fold(0, (sum, p) => sum + (p['stock'] as int)); // Asegurar que es int
    int totalStock = activeStock + inactiveStock;

    return [
      PieChartSectionData(
        value: totalStock > 0 ? activeStock.toDouble() : 0.0,  // Convertir a double
        color: Colors.green,
        title: totalStock > 0 ? 'Activos ($activeStock)' : 'Activos (0)',
        radius: 50,
      ),
      PieChartSectionData(
        value: totalStock > 0 ? inactiveStock.toDouble() : 0.0,  // Convertir a double
        color: Colors.red,
        title: totalStock > 0 ? 'Inactivos ($inactiveStock)' : 'Inactivos (0)',
        radius: 50,
      ),
    ];
  }

  // Generar datos para el gráfico de líneas de stock
  List<FlSpot> _getStockLineData() {
    return List.generate(_productos.length, (index) {
      return FlSpot(index.toDouble(), (_productos[index]['stock'] as int).toDouble()); // Convertir a double
    });
  }

  // Generar datos para el gráfico de líneas de precios
  List<FlSpot> _getPriceLineData() {
    return List.generate(_productos.length, (index) {
      return FlSpot(index.toDouble(), (_productos[index]['precio_unitario'] as num).toDouble()); // Convertir a double
    });
  }
}
