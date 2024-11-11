import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'database_helper.dart';
import 'product_list_screen.dart'; // Screen for selecting products
import 'addclientscreen.dart'; // Screen for adding a new client
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class BillingScreen extends StatefulWidget {
  @override
  _BillingScreenState createState() => _BillingScreenState();
}

class _BillingScreenState extends State<BillingScreen> {
  List<Map<String, dynamic>> clientes = [];
  Map<String, dynamic>? clienteSeleccionado;
  List<Map<String, dynamic>> productosSeleccionados = [];
  double totalFactura = 0.0;
  List<Map<String, dynamic>> empresas = [];
  Map<String, dynamic>? empresaSeleccionada;

  @override
  void initState() {
    super.initState();
    _loadClientes();
    _loadEmpresas(); // Load companies on initialization
  }

  Future<void> _loadClientes() async {
    final db = await DatabaseHelper().database;
    final clientesList = await db.query('Clientes');
    setState(() {
      clientes = clientesList;
    });
  }

  Future<void> _loadEmpresas() async {
    final db = await DatabaseHelper().database;
    final empresasList = await db.query('Empresas');
    setState(() {
      empresas = empresasList;
    });
  }

  Future<void> _agregarProducto() async {
    final producto = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProductListScreen()),
    );

    if (producto != null) {
      setState(() {
        productosSeleccionados.add(producto);
        _calcularTotal();
      });
    }
  }

  void _calcularTotal() {
    totalFactura = productosSeleccionados.fold(0.0, (sum, item) {
      return sum + (item['subtotal'] ?? 0.0);
    });
  }

  Future<int> _generarNumeroFactura() async {
    final db = await DatabaseHelper().database;
    final lastFactura = await db.rawQuery('SELECT MAX(numero_factura) as max_num FROM Facturas');
    int maxNum = (lastFactura.first['max_num'] != null)
        ? int.tryParse(lastFactura.first['max_num'].toString()) ?? 0
        : 0;
    return maxNum + 1;
  }

  Future<void> _imprimirFactura(int numeroFactura) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Factura', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 20),
              pw.Text('Cliente: ${clienteSeleccionado!['nombre']}'),
              pw.Text('C.I.: ${clienteSeleccionado!['ci']}'),
              pw.SizedBox(height: 10),
              if (empresaSeleccionada != null) ...[
                pw.Text('Empresa: ${empresaSeleccionada!['nombre']}'),
                pw.Text('NIT: ${empresaSeleccionada!['NIT']}'),
              ],
              pw.Text('Fecha: ${DateTime.now().toIso8601String()}'),
              pw.Text('Número de Factura: $numeroFactura'),
              pw.SizedBox(height: 20),
              pw.Text('Productos:', style: pw.TextStyle(fontSize: 18)),
              ...productosSeleccionados.map(
                (producto) => pw.Text(
                  '${producto['nombre']} - Cantidad: ${producto['cantidad']} - Subtotal: \$${producto['subtotal'].toStringAsFixed(2)}',
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Text('Total: \$${totalFactura.toStringAsFixed(2)}', style: pw.TextStyle(fontSize: 18)),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  Future<void> _guardarFactura() async {
    if (clienteSeleccionado == null || empresaSeleccionada == null || productosSeleccionados.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Seleccione un cliente, una empresa y al menos un producto')),
      );
      return;
    }

    final db = await DatabaseHelper().database;

    int numeroFactura = await _generarNumeroFactura();

    int facturaId = await db.insert('Facturas', {
      'numero_factura': numeroFactura,
      'id_cliente': clienteSeleccionado!['id_cliente'],
      'id_empresa': empresaSeleccionada!['id_empresa'],
      'fecha': DateTime.now().toIso8601String(),
      'total': totalFactura,
      'estado': 'pendiente',
    });

    for (var producto in productosSeleccionados) {
      await db.insert('Detalle_Factura', {
        'id_factura': facturaId,
        'id_producto': producto['id_producto'],
        'cantidad': producto['cantidad'],
        'precio_unitario': producto['precio_unitario'],
        'subtotal': producto['subtotal'],
      });
    }

    await db.insert('Ventas', {
      'id_factura': facturaId,
      'fecha': DateTime.now().toIso8601String(),
      'total': totalFactura,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Factura guardada con éxito y venta registrada.')),
    );

    await _imprimirFactura(numeroFactura);

    setState(() {
      clienteSeleccionado = null;
      empresaSeleccionada = null;
      productosSeleccionados.clear();
      totalFactura = 0.0;
    });
  }

  Future<void> _agregarCliente() async {
    final nuevoClienteId = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddClientScreen()),
    );

    if (nuevoClienteId != null) {
      await _loadClientes();
      setState(() {
        clienteSeleccionado = clientes.firstWhere(
          (cliente) => cliente['id_cliente'] == nuevoClienteId,
          orElse: () => {'id_cliente': -1, 'nombre': 'No encontrado'},
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crear Factura'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Seleccionar Cliente
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: DropdownButton<String>(
                    hint: Text('Selecciona un cliente'),
                    value: clienteSeleccionado != null
                        ? clienteSeleccionado!['id_cliente'].toString()
                        : null,
                    onChanged: (String? newValue) {
                      setState(() {
                        clienteSeleccionado = clientes.firstWhere(
                          (cliente) => cliente['id_cliente'].toString() == newValue,
                          orElse: () => {'id_cliente': -1, 'nombre': 'No encontrado'},
                        );
                      });
                    },
                    items: clientes.map((cliente) {
                      return DropdownMenuItem<String>(
                        value: cliente['id_cliente'].toString(),
                        child: Text(cliente['nombre']),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _agregarCliente,
                  child: Icon(Icons.person_add, color: Colors.white),
                ),
              ],
            ),
            SizedBox(height: 20),
            // Seleccionar Empresa
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: DropdownButton<String>(
                    hint: Text('Selecciona una empresa'),
                    value: empresaSeleccionada != null
                        ? empresaSeleccionada!['id_empresa'].toString()
                        : null,
                    onChanged: (String? newValue) {
                      setState(() {
                        empresaSeleccionada = empresas.firstWhere(
                          (empresa) => empresa['id_empresa'].toString() == newValue,
                          orElse: () => {'id_empresa': -1, 'nombre': 'No encontrado'},
                        );
                      });
                    },
                    items: empresas.map((empresa) {
                      return DropdownMenuItem<String>(
                        value: empresa['id_empresa'].toString(),
                        child: Text('${empresa['nombre']}'), // Show name and NIT
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            // Button to add products
            ElevatedButton(
              onPressed: _agregarProducto,
              child: Text('Agregar Producto'),
            ),
            SizedBox(height: 20),
            // List of selected products
            Expanded(
              child: ListView.builder(
                itemCount: productosSeleccionados.length,
                itemBuilder: (context, index) {
                  final producto = productosSeleccionados[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    child: ListTile(
                      title: Text(producto['nombre']),
                      subtitle: Text('Cantidad: ${producto['cantidad']} - Subtotal: \$${producto['subtotal']}'),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          setState(() {
                            productosSeleccionados.removeAt(index);
                            _calcularTotal();
                          });
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
            // Total of the invoice
            Text('Total: \$${totalFactura.toStringAsFixed(2)}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            // Button to save the invoice
            ElevatedButton(
              onPressed: _guardarFactura,
              child: Text('Guardar Factura'),
            ),
          ],
        ),
      ),
    );
  }
}
