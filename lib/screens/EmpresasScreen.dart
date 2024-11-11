import 'package:flutter/material.dart';
import 'database_helper.dart';

class Empresas_Screen extends StatefulWidget {
  @override
  _EmpresasScreenState createState() => _EmpresasScreenState();
}

class _EmpresasScreenState extends State<Empresas_Screen> {
  List<Map<String, dynamic>> empresas = [];

  @override
  void initState() {
    super.initState();
    _loadEmpresas();
  }

  // Cargar empresas desde la base de datos
  Future<void> _loadEmpresas() async {
    final db = await DatabaseHelper().database;
    final List<Map<String, dynamic>> listaEmpresas = await db.query('Empresas');
    setState(() {
      empresas = listaEmpresas;
    });
  }

  // Mostrar un cuadro de diálogo para añadir o editar una empresa
  Future<void> _showDialog({Map<String, dynamic>? empresa}) async {
    final nombreController = TextEditingController(text: empresa?['nombre']);
    final rubroController = TextEditingController(text: empresa?['rubro']);
    final nitController = TextEditingController(text: empresa?['NIT']);
    final direccionController = TextEditingController(text: empresa?['direccion']);
    final telefonoController = TextEditingController(text: empresa?['telefono']);
    final emailController = TextEditingController(text: empresa?['email']);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(empresa == null ? 'Añadir Empresa' : 'Editar Empresa'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nombreController,
                  decoration: InputDecoration(labelText: 'Nombre'),
                ),
                TextField(
                  controller: rubroController,
                  decoration: InputDecoration(labelText: 'Rubro'),
                ),
                TextField(
                  controller: nitController,
                  decoration: InputDecoration(labelText: 'NIT'),
                ),
                TextField(
                  controller: direccionController,
                  decoration: InputDecoration(labelText: 'Dirección'),
                ),
                TextField(
                  controller: telefonoController,
                  decoration: InputDecoration(labelText: 'Teléfono'),
                  keyboardType: TextInputType.phone,
                ),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                // Guardar la empresa
                if (empresa == null) {
                  await _addEmpresa(
                    nombreController.text,
                    rubroController.text,
                    nitController.text,
                    direccionController.text,
                    telefonoController.text,
                    emailController.text,
                  );
                  _showSnackBar('Empresa añadida exitosamente.');
                } else {
                  await _updateEmpresa(
                    empresa['id_empresa'],
                    nombreController.text,
                    rubroController.text,
                    nitController.text,
                    direccionController.text,
                    telefonoController.text,
                    emailController.text,
                  );
                  _showSnackBar('Empresa actualizada exitosamente.');
                }
                Navigator.of(context).pop();
              },
              child: Text(empresa == null ? 'Añadir' : 'Guardar'),
            ),
          ],
        );
      },
    );
  }

  // Añadir una nueva empresa
  Future<void> _addEmpresa(String nombre, String rubro, String nit, String direccion, String telefono, String email) async {
    final db = await DatabaseHelper().database;
    await db.insert('Empresas', {
      'nombre': nombre,
      'rubro': rubro,
      'NIT': nit,
      'direccion': direccion,
      'telefono': telefono,
      'email': email,
    });
    _loadEmpresas();
  }

  // Actualizar una empresa existente
  Future<void> _updateEmpresa(int id, String nombre, String rubro, String nit, String direccion, String telefono, String email) async {
    final db = await DatabaseHelper().database;
    await db.update(
      'Empresas',
      {
        'nombre': nombre,
        'rubro': rubro,
        'NIT': nit,
        'direccion': direccion,
        'telefono': telefono,
        'email': email,
      },
      where: 'id_empresa = ?',
      whereArgs: [id],
    );
    _loadEmpresas();
  }

  // Eliminar una empresa
  Future<void> _deleteEmpresa(int id) async {
    final db = await DatabaseHelper().database;
    await db.delete('Empresas', where: 'id_empresa = ?', whereArgs: [id]);
    _loadEmpresas();
    _showSnackBar('Empresa eliminada exitosamente.');
  }

  // Mostrar SnackBar para mensajes
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Empresas', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _showDialog(),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: empresas.length,
        itemBuilder: (context, index) {
          final empresa = empresas[index];
          return Card(
            margin: EdgeInsets.all(8.0),
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              contentPadding: EdgeInsets.all(16),
              title: Text(empresa['nombre'], style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Rubro: ${empresa['rubro']}', style: TextStyle(color: Colors.grey[600])),
                  Text('NIT: ${empresa['NIT']}', style: TextStyle(color: Colors.grey[600])),
                  Text('Teléfono: ${empresa['telefono']}', style: TextStyle(color: Colors.grey[600])),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.blue),
                    onPressed: () => _showDialog(empresa: empresa),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      // Confirmar antes de eliminar
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('Eliminar Empresa'),
                            content: Text('¿Estás seguro de que quieres eliminar esta empresa?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('Cancelar'),
                              ),
                              TextButton(
                                onPressed: () {
                                  _deleteEmpresa(empresa['id_empresa']);
                                  Navigator.of(context).pop();
                                },
                                child: Text('Eliminar'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
