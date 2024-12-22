import 'package:flutter/material.dart';
import 'package:packinglist_for_campers/providers/themes_provider.dart';

Drawer newDrawer({
  required ThemesProvider themesProvider,
  required bool isSwitched,
  required void Function(bool value) onThemeToggle,
}) {
  return Drawer(
    child: ListView(
      children: [
        const DrawerHeader(
          decoration: BoxDecoration(color: Colors.red),
          child: Text(
            'Let\'s go camping!',
            style: TextStyle(fontSize: 24, color: Colors.white),
          ),
        ),
        ListTile(
          title: const Text('Dark Mode'),
          trailing: Switch(
            value: isSwitched,
            onChanged: onThemeToggle,
            activeColor: Colors.red,
          ),
        ),
      ],
    ),
  );
}
