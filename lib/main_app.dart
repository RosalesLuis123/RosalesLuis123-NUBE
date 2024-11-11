import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/perfil_screen.dart';
import 'screens/usuarios_screen.dart';
import 'screens/empresas_screen.dart';
import 'screens/graficos_screen.dart';
import 'screens/ia_screen.dart';
import 'screens/analisis_screen.dart';
import 'screens/planes_screen.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dashboard App',
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/dashboard': (context) => DashboardScreen(),
        '/perfil': (context) => PerfilScreen(),
        '/usuarios': (context) => UsuariosScreen(),
        '/empresas': (context) => EmpresasScreen(),
        '/graficos': (context) => GraficosScreen(),
        '/ia': (context) => IAScreen(),
        '/analisis': (context) => AnalisisScreen(),
        '/planes': (context) => PlanesScreen(),
      },
    );
  }
}
