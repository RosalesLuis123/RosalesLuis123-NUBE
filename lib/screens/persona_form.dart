import 'package:flutter/material.dart';
import 'persona.dart';

class PersonaForm extends StatefulWidget {
  final Persona? persona;
  final Function(Persona) onSubmit;

  PersonaForm({this.persona, required this.onSubmit});

  @override
  _PersonaFormState createState() => _PersonaFormState();
}

class _PersonaFormState extends State<PersonaForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nombreController;
  late TextEditingController _emailController;
  late TextEditingController _telefonoController;
  late TextEditingController _direccionController;
  late String _tipoPersona;

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController(text: widget.persona?.nombre ?? '');
    _emailController = TextEditingController(text: widget.persona?.email ?? '');
    _telefonoController = TextEditingController(text: widget.persona?.telefono ?? '');
    _direccionController = TextEditingController(text: widget.persona?.direccion ?? '');
    _tipoPersona = widget.persona?.tipoPersona ?? 'cliente';
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final persona = Persona(
        id: widget.persona?.id,
        nombre: _nombreController.text,
        email: _emailController.text,
        telefono: _telefonoController.text,
        direccion: _direccionController.text,
        fechaRegistro: DateTime.now(),
        tipoPersona: _tipoPersona,
      );
      widget.onSubmit(persona);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.persona == null ? 'Agregar Persona' : 'Editar Persona'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nombreController,
              decoration: InputDecoration(labelText: 'Nombre'),
              validator: (value) => value == null || value.isEmpty ? 'Ingresa el nombre' : null,
            ),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
              validator: (value) => value == null || value.isEmpty ? 'Ingresa el email' : null,
            ),
            TextFormField(
              controller: _telefonoController,
              decoration: InputDecoration(labelText: 'Teléfono'),
            ),
            TextFormField(
              controller: _direccionController,
              decoration: InputDecoration(labelText: 'Dirección'),
            ),
            DropdownButtonFormField<String>(
              value: _tipoPersona,
              items: ['cliente', 'empleado', 'usuario']
                  .map((tipo) => DropdownMenuItem(value: tipo, child: Text(tipo)))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _tipoPersona = value!;
                });
              },
              decoration: InputDecoration(labelText: 'Tipo de Persona'),
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
