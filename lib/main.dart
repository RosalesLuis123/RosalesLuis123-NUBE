import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'main_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Inicialización de Firebase
  runApp(MyApp());
}
