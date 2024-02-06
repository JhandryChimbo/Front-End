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
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            String? user = snapshot.data;
            return ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                UserAccountsDrawerHeader(
                  accountName: Text(
                    user ?? 'No User',
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                  accountEmail: null,
                  currentAccountPicture: GestureDetector(
                    onTap: () {},
                    child: CircleAvatar(
                      radius: 28,
                      backgroundColor: Colors.white,
                      child: Image.asset(
                        'assets/fondo.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  decoration: const BoxDecoration(
                    color: Colors.orangeAccent,
                    image: DecorationImage(
                      image: AssetImage(
                          'assets/fondo1.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(
                    Icons.person,
                    color: Colors.blue,
                  ),
                  title: const Text(
                    'Perfil',
                    style: TextStyle(fontSize: 16),
                  ),
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/home');
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.list,
                    color: Colors.blue,
                  ),
                  title: const Text(
                    'Lista',
                    style: TextStyle(fontSize: 16),
                  ),
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/animes');
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.map_rounded,
                    color: Colors.green,
                  ),
                  title: const Text(
                    'Mapa',
                    style: TextStyle(fontSize: 16),
                  ),
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/map');
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.exit_to_app,
                    color: Colors.red,
                  ),
                  title: const Text(
                    'Cerrar Sesión',
                    style: TextStyle(fontSize: 16),
                  ),
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
