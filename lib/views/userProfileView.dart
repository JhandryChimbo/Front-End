import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:noticias/controls/servicio_back/FacadeService.dart';
import 'package:validators/validators.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nombresC = TextEditingController();
  final TextEditingController apellidosC = TextEditingController();
  final TextEditingController correoC = TextEditingController();
  final TextEditingController claveC = TextEditingController();

  void _registrar() {
    setState(() {
      FacadeService servicio = FacadeService();
      if (_formKey.currentState!.validate()) {
        Map<String, String> mapa = {
          "correo": correoC.text,
          "clave": claveC.text,
          "nombres": nombresC.text,
          "apellidos": apellidosC.text,
        };
        log(mapa.toString());

        servicio.crearCuentaUsuario(mapa).then((value) async {
          try {
            if (value.code == 200) {
              const SnackBar msg =
                  SnackBar(content: Text("Cuenta Creada correctamente"));
              ScaffoldMessenger.of(context).showSnackBar(msg);
              Navigator.pushReplacementNamed(context, '/home');
            } else {
              final SnackBar msg =
                  SnackBar(content: Text("Error ${value.tag}"));
              ScaffoldMessenger.of(context).showSnackBar(msg);
            }
          } catch (error) {
            print("Error durante la creación de la cuenta: $error");
          }
        }).catchError((error) {
          print("Error durante la creación de la cuenta (catchError): $error");
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
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/fondo.png"),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.black.withOpacity(0.5),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        // const Text(
                        //   "Noticias",
                        //   style: TextStyle(
                        //     color: Colors.black,
                        //     fontWeight: FontWeight.bold,
                        //     fontSize: 30,
                        //   ),
                        //   textAlign: TextAlign.center,
                        // ),
                        const SizedBox(height: 20),
                        const Text(
                          "Registro de Usuarios",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: apellidosC,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Debe ingresar los apellidos";
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            labelText: "Apellidos",
                            prefixIcon: Icon(Icons.person),
                            prefixIconColor: Colors.white,
                            labelStyle: TextStyle(color: Colors.white),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                          ),
                          style: const TextStyle(color: Colors.white),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: nombresC,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Debe ingresar los nombres";
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            labelText: "Nombres",
                            prefixIcon: Icon(Icons.person),
                            prefixIconColor: Colors.white,
                            labelStyle: TextStyle(color: Colors.white),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                          ),
                          style: const TextStyle(color: Colors.white),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: correoC,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Debe ingresar un correo";
                            }
                            if (!isEmail(value)) {
                              return "Debe ingresar un correo válido";
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            labelText: "Correo",
                            prefixIcon: Icon(Icons.email),
                            prefixIconColor: Colors.white,
                            labelStyle: TextStyle(color: Colors.white),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                          ),
                          style: const TextStyle(color: Colors.white),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          obscureText: true,
                          controller: claveC,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Debe ingresar una clave";
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            labelText: "Clave",
                            prefixIcon: Icon(Icons.lock),
                            prefixIconColor: Colors.white,
                            labelStyle: TextStyle(color: Colors.white),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                          ),
                          style: const TextStyle(color: Colors.white),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _registrar,
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.white.withOpacity(0.5),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            side: const BorderSide(color: Colors.white),
                          ),
                          child: const Text(
                            "Registrar",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            const Text(
                              "¿Ya tienes una cuenta?",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  '/home',
                                  (Route<dynamic> route) => false,
                                );
                              },
                              child: const Text(
                                "Inicio de Sesión",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline,
                                    decorationColor: Colors.white),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
