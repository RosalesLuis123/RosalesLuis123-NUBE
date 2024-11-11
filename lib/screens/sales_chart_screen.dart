import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'database_helper.dart';

class SalesChartScreen extends StatefulWidget {
  @override
  _SalesChartScreenState createState() => _SalesChartScreenState();
}

class _SalesChartScreenState extends State<SalesChartScreen> {
  List<Map<String, dynamic>> ventas = [];
  Map<String, double> ventasPorMes = {};
  Map<String, double> ventasPorDia = {};
  double totalVentas = 0.0;

  @override
  void initState() {
    super.initState();
    _loadVentas();
  }

  Future<void> _loadVentas() async {
    final db = await DatabaseHelper().database;
    final result = await db.query('Ventas');

    setState(() {
      ventas = result;

      ventas.forEach((venta) {
        try {
          String fechaString = venta['fecha'];
          String fechaSolo = fechaString.split('T')[0];
          DateTime fecha = DateTime.parse(fechaSolo);
          double total = venta['total'];

          String mes = '${fecha.year}-${fecha.month.toString().padLeft(2, '0')}';
          ventasPorMes[mes] = (ventasPorMes[mes] ?? 0) + total;

          String dia = '${fecha.year}-${fecha.month.toString().padLeft(2, '0')}-${fecha.day.toString().padLeft(2, '0')}';
          ventasPorDia[dia] = (ventasPorDia[dia] ?? 0) + total;

          totalVentas += total;
        } catch (e) {
          print("Error al analizar la fecha: ${venta['fecha']}, error: $e");
        }
      });
    });
  }

  BarChartData _barChartData() {
    return BarChartData(
      titlesData: FlTitlesData(show: true),
      borderData: FlBorderData(show: true),
      barGroups: ventasPorDia.entries.map((entry) {
        DateTime fecha = DateTime.parse(entry.key);
        return BarChartGroupData(
          x: fecha.day,
          barRods: [
            BarChartRodData(
              toY: entry.value,
              color: Colors.blueAccent,
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
          ],
        );
      }).toList(),
    );
  }

  LineChartData _lineChartData() {
    return LineChartData(
      gridData: FlGridData(show: true),
      titlesData: FlTitlesData(show: true),
      borderData: FlBorderData(show: true),
      lineBarsData: [
        LineChartBarData(
          spots: ventasPorMes.entries.map((entry) {
            final date = DateTime.parse('${entry.key}-01');
            return FlSpot(date.month.toDouble(), entry.value);
          }).toList(),
          isCurved: true,
          barWidth: 3,
          color: Colors.blue,
          dotData: FlDotData(show: false),
        ),
      ],
    );
  }

  Widget _buildHistogram() {
    Map<int, int> histogram = {};
    for (var venta in ventas) {
      int rango = (venta['total'] / 100).floor() * 100;
      histogram[rango] = (histogram[rango] ?? 0) + 1;
    }

    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text('Histograma de Montos de Ventas', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(
                height: 250,
                child: BarChart(
                  BarChartData(
                    barGroups: histogram.entries.map((entry) {
                      return BarChartGroupData(
                        x: entry.key,
                        barRods: [BarChartRodData(toY: entry.value.toDouble(), color: Colors.greenAccent)],
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSecondPieChart() {
    Map<String, double> rangoVentas = {
      '0-100': 0,
      '100-500': 0,
      '500-1000': 0,
      '1000+': 0,
    };

    for (var venta in ventas) {
      double total = venta['total'];
      if (total < 100) {
        rangoVentas['0-100'] = rangoVentas['0-100']! + total;
      } else if (total < 500) {
        rangoVentas['100-500'] = rangoVentas['100-500']! + total;
      } else if (total < 1000) {
        rangoVentas['500-1000'] = rangoVentas['500-1000']! + total;
      } else {
        rangoVentas['1000+'] = rangoVentas['1000+']! + total;
      }
    }

    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text('Ventas por Rango de Monto', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(
                height: 250,
                child: PieChart(
                  PieChartData(
                    sections: rangoVentas.entries.map((entry) {
                      return PieChartSectionData(
                        title: '${entry.key}\n${(entry.value / totalVentas * 100).toStringAsFixed(1)}%',
                        value: entry.value,
                        color: Colors.primaries[entry.key.hashCode % Colors.primaries.length],
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWeeklyTrendChart() {
    Map<int, double> ventasPorDiaSemana = {0: 0, 1: 0, 2: 0, 3: 0, 4: 0, 5: 0, 6: 0};

    for (var venta in ventas) {
      DateTime fecha = DateTime.parse(venta['fecha']);
      int diaSemana = fecha.weekday - 1;
      ventasPorDiaSemana[diaSemana] = (ventasPorDiaSemana[diaSemana] ?? 0) + venta['total'];
    }

    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text('Tendencias Semanales', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(
                height: 250,
                child: LineChart(
                  LineChartData(
                    lineBarsData: [
                      LineChartBarData(
                        spots: ventasPorDiaSemana.entries.map((entry) {
                          return FlSpot(entry.key.toDouble(), entry.value);
                        }).toList(),
                        isCurved: true,
                        color: Colors.deepPurpleAccent,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gráficos de Ventas', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildLineChart(),
            _buildBarChart(),
            _buildPieChart(),
            _buildHistogram(),
            _buildSecondPieChart(),
            _buildWeeklyTrendChart(),
          ],
        ),
      ),
    );
  }

  Widget _buildLineChart() {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text('Ventas Mensuales', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 250, child: LineChart(_lineChartData())),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBarChart() {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text('Ventas Diarias', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 250, child: BarChart(_barChartData())),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPieChart() {
    Map<String, double> ventasPorCategoria = {'Categoria A': 300, 'Categoria B': 200, 'Categoria C': 100};

    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text('Ventas por Categoría', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(
                height: 250,
                child: PieChart(
                  PieChartData(
                    sections: ventasPorCategoria.entries.map((entry) {
                      return PieChartSectionData(
                        title: '${entry.key} (${(entry.value / totalVentas * 100).toStringAsFixed(1)}%)',
                        value: entry.value,
                        color: Colors.accents[entry.key.hashCode % Colors.accents.length],
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
