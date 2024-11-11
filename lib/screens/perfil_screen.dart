import 'package:flutter/material.dart';
import '../widgets/app_header.dart';

class PerfilScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppHeader(),
      body: Center(child: Text("Perfil del Usuario")),
    );
  }
}
