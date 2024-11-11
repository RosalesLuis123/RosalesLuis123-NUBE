import 'package:flutter/material.dart';
import '../widgets/app_header.dart';

class PlanesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppHeader(),
      body: Center(child: Text("Gestión de Planes")),
    );
  }
}
