import 'package:flutter/material.dart';

class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  final List<Widget>? actions; // Parámetro opcional para acciones en AppBar

  AppHeader({this.actions});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text("Dashboard App"),
      actions: actions, // Se asigna el parámetro actions al AppBar
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
