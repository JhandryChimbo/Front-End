import 'package:flutter/material.dart';
import 'package:noticias/controls/utiles/Utiles.dart';

class AppDrawer extends StatelessWidget {
  final Utiles utiles = Utiles();

  AppDrawer({Key? key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: FutureBuilder<String?>(
        future: _getUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Display loading indicator while waiting for user data
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            // Handle error case
            return Text('Error: ${snapshot.error}');
          } else {
            // User data retrieved successfully
            String? user = snapshot.data;
            return ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                UserAccountsDrawerHeader(
                  accountName: Text(user ?? 'No User'),
                  accountEmail: null,
                  currentAccountPicture: GestureDetector(
                    onTap: () {},
                    child: const CircleAvatar(
                      child: Icon(
                        Icons.account_circle,
                        size: 56.0,
                      ),
                    ),
                  ),
                  decoration: const BoxDecoration(
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
                  leading: const Icon(Icons.map_rounded),
                  title: const Text('Mapa'),
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/mapa');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.exit_to_app),
                  title: const Text('Cerrar Sesión'),
                  onTap: () {
                    _mostrarDialogoConfirmacion(context);
                  },
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Future<String?> _getUser() async {
    return utiles.getValue('user');
  }

  void _mostrarDialogoConfirmacion(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar salida'),
          content: const Text('¿Estás seguro de que quieres salir?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el cuadro de diálogo
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                utiles.removeAllItem();
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/home',
                  (Route<dynamic> route) => false,
                );
              },
              child: const Text('Salir'),
            ),
          ],
        );
      },
    );
  }
}
