import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:noticias/controls/servicio_back/FacadeService.dart';
import 'package:geolocator/geolocator.dart';
import 'package:noticias/controls/utiles/Utiles.dart';

class ComentarioAnimeView extends StatefulWidget {
  final String animeId;
  final String animeTitulo;
  final String animeCuerpo;
  final String animeFecha;

  const ComentarioAnimeView({
    super.key,
    required this.animeId,
    required this.animeTitulo,
    required this.animeCuerpo,
    required this.animeFecha,
  });

  @override
  _ComentarioAnimeViewState createState() => _ComentarioAnimeViewState();
}

class _ComentarioAnimeViewState extends State<ComentarioAnimeView> {
  final Utiles utiles = Utiles();
  final _formKey = GlobalKey<FormState>();
  List<Map<String, dynamic>> comentariosAnime = [];
  String? _editingCommentId;
  int _loadedComments = 10;

  final TextEditingController comentarioController = TextEditingController();

  Future<String?> _modificarComentario(
      String idComentario, TextEditingController editado) async {
    if (editado.text.isEmpty) {
      const SnackBar msg =
          SnackBar(content: Text('El comentario no puede estar vacío'));
      ScaffoldMessenger.of(context).showSnackBar(msg);
      return null;
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.medium,
    );
    double latitud = position.latitude;
    double longitud = position.longitude;

    // Fecha
    DateTime now = DateTime.now();
    String fecha = now.toIso8601String();

    setState(() {
      FacadeService servicio = FacadeService();
      Map<String, String> mapa = {
        "cuerpo": editado.text,
        "fecha": fecha,
        "longitud": longitud.toString(),
        "latitud": latitud.toString(),
      };
      log(mapa.toString());

      servicio.modificarComentario(mapa, idComentario).then((value) async {
        try {
          if (value.code == 200) {
            const SnackBar msg =
                SnackBar(content: Text("Comentario modificado correctamente"));
            ScaffoldMessenger.of(context).showSnackBar(msg);
            _listarComentarios();
          } else {
            final SnackBar msg = SnackBar(content: Text("Error ${value.msg}"));
            ScaffoldMessenger.of(context).showSnackBar(msg);
          }
        } catch (error) {
          print("Error durante la modificacion de la cuenta: $error");
        }
      }).catchError((error) {
        print(
            "Error durante la modificacion de la cuenta (catchError): $error");
      });
    });
    return null;
  }

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
          _listarComentarios();
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

  Future<void> _enviarComentario() async {
    if (_formKey.currentState!.validate()) {
      try {
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.medium,
        );
        double latitud = position.latitude;
        double longitud = position.longitude;

        // Fecha
        DateTime now = DateTime.now();
        String fecha = now.toIso8601String();

        //Persona
        Utiles util = Utiles();
        String? idPersonaLogeada = await util.getValue('id');

        // Id anime
        String idAnime = widget.animeId;

        FacadeService servicio = FacadeService();
        Map<String, dynamic> comentarioMap = {
          'cuerpo': comentarioController.text,
          'fecha': fecha,
          'longitud': longitud,
          'latitud': latitud,
          'persona': idPersonaLogeada,
          'anime': idAnime,
        };

        servicio.enviarComentario(comentarioMap).then((response) {
          if (response.code == 200) {
            const SnackBar msg = SnackBar(content: Text('Comentario enviado'));
            ScaffoldMessenger.of(context).showSnackBar(msg);
            comentarioController.clear();
            _listarComentarios();
          } else {
            const SnackBar msg =
                SnackBar(content: Text('Error al enviar comentario'));
            ScaffoldMessenger.of(context).showSnackBar(msg);
          }
        }).catchError((error) {
          print('Error al enviar comentario: $error');
        });
      } catch (e) {
        print('Error al obtener la ubicación: $e');
      }
    }
  }

  void _mostrarDialogoBaneo(String userId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Banear Usuario'),
          content:
              const Text('¿Estás seguro de que deseas banear a este usuario?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                _cambiarEstadoUsuario(userId, false);
                Navigator.of(context).pop();
              },
              child: const Text('Banear'),
            ),
          ],
        );
      },
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

  Future<void> _listarComentarios() async {
    try {
      FacadeService servicio = FacadeService();
      var response = await servicio.listarComentarios();

      if (response.code == 200) {
        List<Map<String, dynamic>> comentarios =
            List<Map<String, dynamic>>.from(response.datos);

        setState(() {
          comentariosAnime = comentarios
              .where((comentario) =>
                  comentario['anime']['id'] == widget.animeId &&
                  comentario['estado'] == true &&
                  comentario['persona']['cuenta']['estado'] == true)
              .toList();
        });
      } else {
        print('Error: ${response.msg}');
      }
    } catch (e) {
      print('Excepción: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _listarComentarios();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Comentarios de ${widget.animeTitulo}'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildAnimeCard(),
            _buildComentarioForm(),
            _buildComentariosList(),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimeCard() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                widget.animeTitulo,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.animeCuerpo,
              style: const TextStyle(
                fontSize: 16,
              ),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Fecha de Estreno: ${widget.animeFecha}',
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildComentarioForm() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Agregar Comentario',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Form(
            key: _formKey,
            child: TextFormField(
              controller: comentarioController,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Debe ingresar un comentario';
                }
                return null;
              },
              decoration: const InputDecoration(
                labelText: 'Comentario',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              _enviarComentario();
            },
            child: const Text('Enviar Comentario'),
          ),
        ],
      ),
    );
  }

  Widget _buildComentariosList() {
    return Column(
      children: [
        const SizedBox(height: 10),
        const Text(
          'Comentarios del anime',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        if (comentariosAnime.isNotEmpty)
          FutureBuilder<Map<String, dynamic>>(
            future: _getUserInfo(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }

              if (snapshot.hasError || snapshot.data == null) {
                return const Text('Error al obtener la id del usuario logeado');
              }

              Map<String, dynamic> userInfo = snapshot.data!;
              return Column(
                children: [
                  ...comentariosAnime.reversed
                      .take(_loadedComments)
                      .map((comentario) {
                    bool isOwner =
                        comentario['persona']['id'] == userInfo['id'];

                    bool isAdmin = userInfo.containsKey('rol') &&
                        userInfo['rol'] != null &&
                        userInfo['rol']['nombre'] == 'admin';

                    return GestureDetector(
                      onTap: isAdmin
                          ? () {
                              _mostrarDialogoBaneo(comentario['persona']['id']);
                            }
                          : null,
                      child: Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                comentario['persona']['nombres'] +
                                    ' ' +
                                    comentario['persona']['apellidos'],
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 5),
                              if (_editingCommentId != comentario['id'])
                                Text('${comentario['cuerpo']}'),
                              if (_editingCommentId == comentario['id'])
                                _buildEditCommentForm(comentario['id']),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  if (isOwner && _editingCommentId == null)
                                    ElevatedButton(
                                      onPressed: () {
                                        print('ID: ${comentario['id']}');
                                        setState(() {
                                          _editingCommentId = comentario['id'];
                                        });
                                      },
                                      child: const Text('Editar'),
                                    ),
                                  Text(
                                    '${comentario['fecha']}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                  if (_loadedComments < comentariosAnime.length)
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _loadedComments += 10;
                        });
                      },
                      child: const Text('Cargar Más Comentarios'),
                    ),
                ],
              );
            },
          )
        else
          const Text('No hay comentarios para este anime.'),
      ],
    );
  }

  Widget _buildEditCommentForm(String commentId) {
    final TextEditingController editadoController = TextEditingController(
        text: comentariosAnime.firstWhere(
            (comentario) => comentario['id'] == commentId)['cuerpo']);

    return Form(
      child: Column(
        children: [
          TextFormField(
            controller: editadoController,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Debe ingresar un comentario';
              }
              return null;
            },
            decoration: const InputDecoration(
              labelText: 'Comentario',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              print(editadoController.text);
              _modificarComentario(commentId, editadoController);
              _listarComentarios();
              setState(() {
                _editingCommentId = null;
              });
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }
}
