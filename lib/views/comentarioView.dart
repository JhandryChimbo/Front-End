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
    Key? key,
    required this.animeId,
    required this.animeTitulo,
    required this.animeCuerpo,
    required this.animeFecha,
  }) : super(key: key);

  @override
  _ComentarioAnimeViewState createState() => _ComentarioAnimeViewState();
}

class _ComentarioAnimeViewState extends State<ComentarioAnimeView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController comentarioController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Comentarios de ${widget.animeTitulo}'),
        ),
        body: ListView(
          shrinkWrap: true,
          children: [
            _buildAnimeCard(),
            _buildComentarioForm(),
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
            // Agrega aquí tu lógica para mostrar y manejar los comentarios
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
          TextFormField(
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

  Future<void> _enviarComentario() async {
    print('ID del anime al enviar el comentario: ${widget.animeId}');

    if (_formKey.currentState!.validate()) {
      try {
        // Obtener la ubicación actual
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );

        // Utilizar position.latitude y position.longitude para obtener latitud y longitud
        double latitud = position.latitude;
        double longitud = position.longitude;

        // Obtener la fecha actual
        DateTime now = DateTime.now();
        String fecha = now.toIso8601String();

        // Obtener la ID de la persona logeada (aquí estoy usando un valor ficticio, reemplázalo según tu lógica de autenticación)

        Utiles util = Utiles();
        String? idPersonaLogeada = await util.getValue('id');

        // Obtener la ID del anime al cual se está comentando
        String idAnime = widget.animeId;

        // Lógica para enviar el comentario
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

            // Limpiar el TextFormField después de enviar el comentario exitosamente
            comentarioController.clear();
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
        // Manejar el error según sea necesario
      }
    }
  }
}
