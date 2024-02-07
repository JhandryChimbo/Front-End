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
  final _formKey = GlobalKey<FormState>();
  List<Map<String, dynamic>> comentariosAnime = [];
  

  final TextEditingController comentarioController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _listarComentarios(); // Load comments when the screen initializes
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
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.animeTitulo,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Text('Cuerpo: ${widget.animeCuerpo}'),
            Text('Fecha Estreno: ${widget.animeFecha}'),
            const SizedBox(height: 10),
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
          Column(
            children: comentariosAnime.reversed.map((comentario) {
              // Invertir la lista
              return Card(
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
                      Text('Fecha: ${comentario['fecha']}'),
                      Text('Cuerpo: ${comentario['cuerpo']}'),
                    ],
                  ),
                ),
              );
            }).toList(),
          )
        else
          const Text('No hay comentarios para este anime.'),
      ],
    );
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

  Future<void> _listarComentarios() async {
    try {
      FacadeService servicio = FacadeService();
      var response = await servicio.listarComentarios();

      if (response.code == 200) {
        List<Map<String, dynamic>> comentarios =
            List<Map<String, dynamic>>.from(response.datos);

        setState(() {
          comentariosAnime = comentarios
              .where(
                  (comentario) => comentario['anime']['id'] == widget.animeId)
              .toList();
        });
      } else {
        print('Error: ${response.msg}');
      }
    } catch (e) {
      print('Excepción: $e');
    }
  }
}
