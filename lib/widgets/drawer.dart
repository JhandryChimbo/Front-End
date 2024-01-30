import 'package:flutter/material.dart';
import 'package:noticias/controls/utiles/Utiles.dart';

class AppDrawer extends StatelessWidget {
  final Utiles utiles = Utiles();

  AppDrawer({Key? key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const UserAccountsDrawerHeader(
            accountName: Text('Crunchy Roll'),
            accountEmail: null,
            currentAccountPicture: CircleAvatar(
              backgroundImage: AssetImage('assets/fondo.png'),
            ),
            decoration: BoxDecoration(
              color: Colors.orangeAccent,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Perfil'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/home');
            },
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Salir'),
            onTap: () {
              _mostrarDialogoConfirmacion(context);
            },
          ),
        ],
      ),
    );
  }

  void _mostrarDialogoConfirmacion(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar salida'),
          content: Text('¿Estás seguro de que quieres salir?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el cuadro de diálogo
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                utiles.removeAllItem();
                Navigator.pushReplacementNamed(context, '/home');
              },
              child: Text('Salir'),
            ),
          ],
        );
      },
    );
  }
}

