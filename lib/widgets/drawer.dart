import 'package:flutter/material.dart';
import 'package:noticias/controls/servicio_back/FacadeService.dart';
import 'package:noticias/controls/utiles/Utiles.dart';

class AppDrawer extends StatelessWidget {
  final Utiles utiles = Utiles();

  AppDrawer({Key? key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: FutureBuilder<Map<String, dynamic>>(
        future: _getUserInfo(),
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
            Map<String, dynamic> userInfo = snapshot.data!;
            bool isAdmin = userInfo.containsKey('rol') &&
                userInfo['rol'] != null &&
                userInfo['rol']['nombre'] == 'admin';

            return ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                UserAccountsDrawerHeader(
                  accountName: Text(
                    userInfo['nombres'] ?? 'No User',
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
                      image: AssetImage('assets/fondo1.png'),
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
                    Navigator.pushReplacementNamed(context, '/profile');
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
                if (isAdmin)
                  ListTile(
                    leading: const Icon(
                      Icons.person_search,
                      color: Colors.green,
                    ),
                    title: const Text(
                      'Usuarios',
                      style: TextStyle(fontSize: 16),
                    ),
                    onTap: () {
                      Navigator.pushReplacementNamed(context, '/usuarios');
                    },
                  ),
                if (isAdmin)
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

  Future<Map<String, dynamic>> _getUserInfo() async {
    String? idPersonaLogeada = await utiles.getValue('id');

    if (idPersonaLogeada != null) {
      FacadeService servicio = FacadeService();
      var response = await servicio.obtenerUsuario(idPersonaLogeada);
      if (response.code == 200) {
        return Map<String, dynamic>.from(response.datos);
      } else {
        throw Exception('Error obteniendo información del usuario');
      }
    } else {
      throw Exception('ID de persona logeada es nulo');
    }
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
                Navigator.of(context).pop();
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
