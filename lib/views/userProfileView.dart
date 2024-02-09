import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:noticias/controls/servicio_back/FacadeService.dart';
import 'package:noticias/controls/utiles/Utiles.dart';
import 'package:noticias/widgets/drawer.dart';

class UserProfileView extends StatefulWidget {
  const UserProfileView({Key? key}) : super(key: key);

  @override
  _UserProfileViewState createState() => _UserProfileViewState();
}

class _UserProfileViewState extends State<UserProfileView> {
  Map<String, dynamic> usuario = {};

  final _formKey = GlobalKey<FormState>();
  final TextEditingController nombresControl = TextEditingController();
  final TextEditingController apellidosControl = TextEditingController();
  final TextEditingController direccionControl = TextEditingController();
  final TextEditingController celularControl = TextEditingController();
  final TextEditingController fechaControl = TextEditingController();

  Future<void> _iniciar() async {
    Utiles util = Utiles();
    String? idPersonaLogeada = await util.getValue('id');
    setState(() {
      FacadeService servicio = FacadeService();
      if (_formKey.currentState!.validate()) {
        Map<String, String> mapa = {
          "nombres": nombresControl.text,
          "apellidos": apellidosControl.text,
          "direccion": direccionControl.text,
          "celular": celularControl.text,
          "fecha": fechaControl.text
        };
        log(mapa.toString());

        servicio.modificarUsuario(mapa, idPersonaLogeada!).then((value) async {
          try {
            if (value.code == 200) {
              const SnackBar msg =
                  SnackBar(content: Text("Cuenta modificada correctamente"));
              ScaffoldMessenger.of(context).showSnackBar(msg);
              _obtenerUsuario();
              // Navigator.pushReplacementNamed(context, '/home');
            } else {
              final SnackBar msg =
                  SnackBar(content: Text("Error ${value.msg}"));
              ScaffoldMessenger.of(context).showSnackBar(msg);
            }
          } catch (error) {
            print("Error durante la modificacion de la cuenta: $error");
          }
        }).catchError((error) {
          print(
              "Error durante la modificacion de la cuenta (catchError): $error");
        });
      } else {
        log("Errores");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil de Usuario'),
      ),
      drawer: AppDrawer(),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: _buildUserProfile(),
      ),
    );
  }

  Widget _buildUserProfile() {
    if (usuario.isEmpty) {
      return const Center(child: Text('No hay data'));
    } else {
      return _buildUserProfileForm(usuario);
    }
  }

  Widget _buildUserProfileForm(Map<String, dynamic> user) {
    nombresControl.text = user['nombres'] ?? '';
    apellidosControl.text = user['apellidos'] ?? '';
    direccionControl.text = user['direccion'] ?? '';
    celularControl.text = user['celular'] ?? '';
    fechaControl.text = user['fecha_nacimiento'] ?? '';

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: nombresControl,
            decoration: InputDecoration(
              labelText: 'Nombres',
              hintText:
                  nombresControl.text == 'NONE' ? 'Ingrese su nombre' : null,
              prefixIcon: const Icon(Icons.person),
            ),
            validator: (value) {
              if (value == null || value.isEmpty || value == 'NONE') {
                return 'Ingrese su nombre';
              }
              return null;
            },
          ),
          TextFormField(
            controller: apellidosControl,
            decoration: InputDecoration(
              labelText: 'Apellidos',
              hintText: apellidosControl.text == 'NONE'
                  ? 'Ingrese sus apellidos'
                  : null,
              prefixIcon: const Icon(Icons.person),
            ),
            validator: (value) {
              if (value == null || value.isEmpty || value == 'NONE') {
                return 'Ingrese sus apellidos';
              }
              return null;
            },
          ),
          TextFormField(
            controller: direccionControl,
            decoration: InputDecoration(
              labelText: 'Dirección',
              hintText: direccionControl.text == 'NONE'
                  ? 'Ingrese su dirección'
                  : null,
              prefixIcon: const Icon(Icons.location_on),
            ),
            validator: (value) {
              if (value == null || value.isEmpty || value == 'NONE') {
                return 'Ingrese su dirección';
              }
              return null;
            },
          ),
          TextFormField(
            controller: celularControl,
            decoration: InputDecoration(
              labelText: 'Celular',
              hintText: celularControl.text == 'NONE'
                  ? 'Ingrese su número de celular'
                  : null,
              prefixIcon: const Icon(Icons.phone),
            ),
            validator: (value) {
              if (value == null || value.isEmpty || value == 'NONE') {
                return 'Ingrese su número de celular';
              }
              return null;
            },
          ),
          TextFormField(
            controller: fechaControl,
            decoration: InputDecoration(
              labelText: 'Fecha de Nacimiento',
              hintText: fechaControl.text == 'NONE'
                  ? 'Ingrese su fecha de nacimiento'
                  : null,
              prefixIcon: const Icon(Icons.date_range),
            ),
            validator: (value) {
              if (value == null || value.isEmpty || value == 'NONE') {
                return 'Ingrese su fecha de nacimiento';
              }
              return null;
            },
          ),
          TextFormField(
            initialValue: '${user['cuenta']['correo']}',
            decoration: const InputDecoration(
              labelText: 'Correo',
              prefixIcon: Icon(Icons.email),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () {
              _iniciar();
            },
            icon: const Icon(Icons.save),
            label: const Text('Guardar'),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _obtenerUsuario();
  }

  Future<void> _obtenerUsuario() async {
    try {
      Utiles util = Utiles();
      String? idPersonaLogeada = await util.getValue('id');
      if (idPersonaLogeada != null) {
        FacadeService servicio = FacadeService();
        var response = await servicio.obtenerUsuario(idPersonaLogeada);
        if (response.code == 200) {
          setState(() {
            usuario = Map<String, dynamic>.from(response.datos);
          });
        } else {
          print('Error: ${response.msg}');
        }
      } else {
        print('Error: ID de persona logeada es nulo');
      }
    } catch (e) {
      print('Excepción: $e');
    }
  }
}
