import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/app_header.dart';
import '../widgets/dashboard_item.dart';
import 'login_screen.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppHeader(
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: GridView.count(
        crossAxisCount: 2,
        children: [
          DashboardItem(
              title: 'Personas', icon: Icons.people, route: '/Personas'),
          DashboardItem(
              title: 'Empresas', icon: Icons.business, route: '/empresas'),
          DashboardItem(
              title: 'Gráficos', icon: Icons.show_chart, route: '/graficos'),
          DashboardItem(title: 'IA', icon: Icons.computer, route: '/ia'),
          DashboardItem(
              title: 'Análisis', icon: Icons.analytics, route: '/analisis'),
          DashboardItem(
              title: 'Planes', icon: Icons.card_membership, route: '/planes'),
        ],
      ),
    );
  }
}
