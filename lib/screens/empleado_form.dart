import 'package:flutter/material.dart';
import 'empleado.dart';

class EmpleadoForm extends StatefulWidget {
  final Empleado? empleado;  // null cuando es nuevo empleado
  final Function(Empleado) onSubmit;

  EmpleadoForm({this.empleado, required this.onSubmit});

  @override
  _EmpleadoFormState createState() => _EmpleadoFormState();
}

class _EmpleadoFormState extends State<EmpleadoForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _cargoController;
  late TextEditingController _salarioController;
  late DateTime _fechaContratacion;

  @override
  void initState() {
    super.initState();
    _cargoController = TextEditingController(text: widget.empleado?.cargo ?? '');
    _salarioController = TextEditingController(
        text: widget.empleado != null ? widget.empleado!.salario.toString() : '');
    _fechaContratacion = widget.empleado?.fechaContratacion ?? DateTime.now();
  }

  @override
  void dispose() {
    _cargoController.dispose();
    _salarioController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final empleado = Empleado(
        id: widget.empleado?.id,
        idPersona: widget.empleado?.idPersona ?? 1,  // Ajustar según los datos requeridos
        idEmpresa: widget.empleado?.idEmpresa ?? 1,  // Ajustar según los datos requeridos
        cargo: _cargoController.text,
        salario: double.parse(_salarioController.text),
        fechaContratacion: _fechaContratacion,
      );
      widget.onSubmit(empleado);
      Navigator.of(context).pop();
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _fechaContratacion,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null && pickedDate != _fechaContratacion) {
      setState(() {
        _fechaContratacion = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.empleado == null ? 'Agregar Empleado' : 'Editar Empleado'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _cargoController,
              decoration: InputDecoration(labelText: 'Cargo'),
              validator: (value) => value == null || value.isEmpty ? 'Ingresa el cargo' : null,
            ),
            TextFormField(
              controller: _salarioController,
              decoration: InputDecoration(labelText: 'Salario'),
              keyboardType: TextInputType.number,
              validator: (value) =>
                  value == null || value.isEmpty ? 'Ingresa el salario' : null,
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Text('Fecha de contratación: ${_fechaContratacion.toLocal()}'.split(' ')[0]),
                IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () => _selectDate(context),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: _submitForm,
          child: Text('Guardar'),
        ),
      ],
    );
  }
}
