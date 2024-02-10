import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:noticias/controls/servicio_back/FacadeService.dart';
import 'package:noticias/widgets/drawer.dart';

class UserListView extends StatefulWidget {
  const UserListView({super.key});

  @override
  _UserListViewState createState() => _UserListViewState();
}

class _UserListViewState extends State<UserListView> {
  List<Map<String, dynamic>> usuarios = [];

  void _cambiarEstadoUsuario(String usuarioId, bool nuevoEstado) {
    FacadeService servicio = FacadeService();

    Map<String, String> mapa = {
      "estado": nuevoEstado.toString(),
    };
    log(mapa.toString());

    servicio.modificarEstadoUsuario(usuarioId, mapa).then((value) async {
      try {
        if (value.code == 200) {
          String mensaje;
          if (nuevoEstado) {
            mensaje = "Cuenta activada correctamente";
          } else {
            mensaje = "Cuenta desactivada correctamente";
          }

          final SnackBar msg = SnackBar(content: Text(mensaje));
          ScaffoldMessenger.of(context).showSnackBar(msg);
          _listarUsuarios();
        } else {
          final SnackBar msg = SnackBar(content: Text("Error ${value.msg}"));
          ScaffoldMessenger.of(context).showSnackBar(msg);
        }
      } catch (error) {
        print("Error durante la modificación de la cuenta: $error");
      }
    }).catchError((error) {
      print("Error durante la modificación de la cuenta (catchError): $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Usuarios'),
      ),
      drawer: AppDrawer(),
      body: Container(
        child: _buildUserList(),
      ),
    );
  }

  Widget _buildUserList() {
    if (usuarios.isEmpty) {
      return const Center(child: Text('No hay usuarios.'));
    } else {
      return ListView.separated(
        itemCount: usuarios.length,
        separatorBuilder: (context, index) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          var user = usuarios[index];
          return _buildUserCard(user);
        },
      );
    }
  }

  Widget _buildUserCard(Map<String, dynamic> user) {
    return Card(
      elevation: 5,
      shadowColor: Colors.grey,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: InkWell(
        onTap: () {},
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      '${user['nombres']} ${user['apellidos']}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text('Dirección: ${user['direccion']}'),
                  Text('Celular: ${user['celular'] ?? 'NONE'}'),
                  Text(
                      'Fecha Nacimiento: ${user['fecha_nacimiento'] ?? 'NONE'}'),
                  Text('Correo: ${user['cuenta']['correo']}'),
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: user['cuenta']['estado']
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),
                      Text(
                        user['cuenta']['estado'] ? 'Activo' : 'Baneado',
                        style: TextStyle(
                          color: user['cuenta']['estado']
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      _cambiarEstadoUsuario(
                          user['id'], !user['cuenta']['estado']);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          user['cuenta']['estado'] ? Colors.red : Colors.green,
                    ),
                    child: Text(
                      user['cuenta']['estado'] ? 'Banear' : 'Activar',
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _listarUsuarios();
  }

  Future<void> _listarUsuarios() async {
    try {
      FacadeService servicio = FacadeService();
      var response = await servicio.listarUsuarios();

      if (response.code == 200) {
        setState(() {
          usuarios = List<Map<String, dynamic>>.from(response.datos);
        });
      } else {
        print('Error: ${response.msg}');
      }
    } catch (e) {
      print('Excepción: $e');
    }
  }
}
