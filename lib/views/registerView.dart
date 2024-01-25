import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:noticias/controls/servicio_back/FacadeService.dart';
import 'package:noticias/controls/utiles/Utiles.dart';
import 'package:validators/validators.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final TextEditingController nombresC = TextEditingController();
    final TextEditingController apellidosC = TextEditingController();
    final TextEditingController correoC = TextEditingController();
    final TextEditingController claveC = TextEditingController();
    final TextEditingController direccionC = TextEditingController();
    final TextEditingController fechaC = TextEditingController();
    final TextEditingController celularC = TextEditingController();

    void _iniciar() {
    setState(() {
      FacadeService servicio = FacadeService();
      if (_formKey.currentState!.validate()) {
        Map<String, String> mapa = {
          "correo": correoC.text,
          "clave": claveC.text,
          "nombres": nombresC.text,
          "apellidos": apellidosC.text,
          "direccion": direccionC.text,
          "celular": celularC.text,
          "fecha": fechaC.text,
        };
        log(mapa.toString());

        servicio.crearCuentaUsuario(mapa).then((value) async {
          if (value.code == 200) {
            log(value.datos['token']);
            log(value.datos['user']);
            Utiles util = Utiles();
            util.saveValue('token', value.datos['token']);
            util.saveValue('user', value.datos['user']);
            util.saveValue('external_id', value.datos['external_id']);
            final SnackBar msg =
                SnackBar(content: Text("Cuenta Creada ${value.datos['user']}"));
            ScaffoldMessenger.of(context).showSnackBar(msg);
          } else {
            final SnackBar msg = SnackBar(content: Text("Error ${value.tag}"));
            ScaffoldMessenger.of(context).showSnackBar(msg);
          }
        });
      } else {
        log("Errores");
      }
    });
  }

    return Form(
      key: _formKey,
      child: Scaffold(
        body: ListView(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
            ),
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(10),
              child: const Text(
                "VsCode>>>>AndroidStuido",
                style: TextStyle(fontSize: 30),
              ),
            ),
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(10),
              child: const Text(
                "Registro de Usuarios",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextFormField(
                controller: apellidosC,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Debe ingresar los apellidos";
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: "Apellidos",
                  suffixIcon: Icon(Icons.supervised_user_circle),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextFormField(
                controller: nombresC,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Debe ingresar los nombres";
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: "Nombres",
                  suffixIcon: Icon(Icons.supervised_user_circle),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextFormField(
                controller: direccionC,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Debe ingresar la direccion";
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: "Direccion",
                  suffixIcon: Icon(Icons.supervised_user_circle),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextFormField(
                controller: celularC,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Debe ingresar el celular";
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: "Celular",
                  suffixIcon: Icon(Icons.supervised_user_circle),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextFormField(
                controller: fechaC,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Debe ingresar la fecha de nacimiento";
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: "Fecha de nacimiento",
                  suffixIcon: Icon(Icons.supervised_user_circle),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextFormField(
                controller: correoC,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Debe ingresar una correo";
                  }
                  if (!isEmail(value)) {
                    return "Debe ingresar una correo valido";
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: "Correo",
                  suffixIcon: Icon(Icons.alternate_email),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextFormField(
                obscureText: true,
                controller: claveC,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Debe ingresar la clave";
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: "Clave",
                  suffixIcon: Icon(Icons.password),
                ),
              ),
            ),
            Container(
              height: 50,
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: ElevatedButton(
                onPressed: _iniciar,
                child: const Text("Registrar"),
              ),
            ),
            Row(
              children: <Widget>[
                const Text("Ya tienes una cuenta"),
                TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/home');
                    },
                    child: const Text(
                      "Inicio de sesion",
                      style: TextStyle(fontSize: 20),
                    ))
              ],
            )
          ],
        ),
      ),
    );
  }
}
