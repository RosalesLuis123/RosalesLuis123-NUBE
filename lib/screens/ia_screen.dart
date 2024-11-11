import 'package:flutter/material.dart';
import '../widgets/app_header.dart';

class IAScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppHeader(),
      body: Center(child: Text("Inteligencia Artificial")),
    );
  }
}
