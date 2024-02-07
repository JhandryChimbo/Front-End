// import 'dart:developer';

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

  void _banearUsuario(String usuarioId) {
    FacadeService servicio = FacadeService();
    servicio.banearUsuario(usuarioId).then((value) async {
      try {
        if (value.code == 200) {
          const SnackBar msg =
              SnackBar(content: Text("Cuenta baneada correctamente"));
          ScaffoldMessenger.of(context).showSnackBar(msg);
          // Refresh the user list after banning
          _listarUsuarios();
        } else {
          final SnackBar msg = SnackBar(content: Text("Error ${value.msg}"));
          ScaffoldMessenger.of(context).showSnackBar(msg);
        }
      } catch (error) {
        print("Error durante la modificacion de la cuenta: $error");
      }
    }).catchError((error) {
      print("Error durante la modificacion de la cuenta (catchError): $error");
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
              padding: const EdgeInsets.all(10),
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
                  Text('Rol: ${user['rol']['nombre']}'),
                  Text(
                    'Estado: ${user['cuenta']['estado'] ? 'Activo' : 'Inactivo'}',
                    style: TextStyle(
                        color: user['cuenta']['estado']
                            ? Colors.green
                            : Colors.red),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      _banearUsuario(user['id']);
                    },
                    child: Text('Banear'),
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
