import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:noticias/controls/servicio_back/FacadeService.dart';
import 'package:noticias/controls/utiles/Utiles.dart';
import 'package:validators/validators.dart';

class SessionView extends StatefulWidget {
  const SessionView({Key? key}) : super(key: key);

  @override
  _SessionViewState createState() => _SessionViewState();
}

class _SessionViewState extends State<SessionView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController correoControl = TextEditingController();
  final TextEditingController claveControl = TextEditingController();

  void _iniciar() {
    setState(() {
      FacadeService servicio = FacadeService();
      if (_formKey.currentState!.validate()) {
        Map<String, String> mapa = {
          "correo": correoControl.text,
          "clave": claveControl.text
        };
        log(mapa.toString());

        servicio.inicioSesion(mapa).then((value) async {
          if (value.code == 200) {
            log(value.datos['token']);
            log(value.datos['user']);
            Utiles util = Utiles();
            util.saveValue('token', value.datos['token']);
            util.saveValue('user', value.datos['user']);
            util.saveValue('external_id', value.datos['external_id']);
            final SnackBar msg =
                SnackBar(content: Text("BIENVENIDO ${value.datos['user']}"));
            ScaffoldMessenger.of(context).showSnackBar(msg);
            Navigator.pushNamed(context, '/animes');
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

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
          body: ListView(
        padding: const EdgeInsets.all(32),
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(10),
            child: const Text(
              "Animes",
              style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                  fontSize: 30),
            ),
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
              "Inicio de Sesion",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: TextFormField(
              controller: correoControl,
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
              controller: claveControl,
              validator: (value) {
                if (value!.isEmpty) {
                  return "Debe ingresar una clave";
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
              child: const Text("Inicio"),
            ),
          ),
          Row(
            children: <Widget>[
              const Text("No tienes una cuenta"),
              TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/register');
                  },
                  child: const Text(
                    "Registrate",
                    style: TextStyle(fontSize: 20),
                  ))
            ],
          )
        ],
      )),
    );
  }
}
