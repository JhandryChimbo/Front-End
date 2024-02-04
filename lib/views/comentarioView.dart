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
  List<Map<String, dynamic>> comentarios = [];
  final _formKey = GlobalKey<FormState>();
  final TextEditingController comentarioController = TextEditingController();

  int comentariosPorPagina = 10;
  int paginaActual = 1;
  bool cargandoComentarios = false;

  @override
  void initState() {
    super.initState();
    _listarComentarios();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Comentarios de ${widget.animeTitulo}'),
        ),
        body: Column(
          children: [
            _buildAnimeCard(),
            _buildComentarioForm(),
            Expanded(
              child: _buildComentariosList(),
            ),
            _buildPaginationButtons(),
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

  Widget _buildComentariosList() {
    return ListView.builder(
      itemCount: comentarios.length,
      itemBuilder: (context, index) {
        String nombrePersona = comentarios[index]['persona']['nombres'];
        String apellidosPersona = comentarios[index]['persona']['apellidos'];

        return ListTile(
          title: Text('$nombrePersona $apellidosPersona dice:'),
          subtitle: Text(comentarios[index]['cuerpo']),
        );
      },
    );
  }

  Widget _buildPaginationButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: paginaActual > 1 ? _retrocederPagina : null,
          child: const Text('Anterior'),
        ),
        const SizedBox(width: 10),
        ElevatedButton(
          onPressed: _cargarMasComentarios,
          child: const Text('Siguiente'),
        ),
      ],
    );
  }

  void _retrocederPagina() {
    if (paginaActual > 1) {
      setState(() {
        paginaActual--;
        _listarComentarios();
      });
    }
  }

  Future<void> _cargarMasComentarios() async {
    if (!cargandoComentarios) {
      setState(() {
        cargandoComentarios = true;
      });

      try {
        FacadeService servicio = FacadeService();
        var response = await servicio.listarComentarios(
          widget.animeId,
          pagina: paginaActual + 1,
          cantidad: comentariosPorPagina,
        );

        if (response.code == 200) {
          setState(() {
            comentarios.addAll(List<Map<String, dynamic>>.from(response.datos));
            paginaActual++;
          });
        } else {
          print('Error: ${response.msg}');
        }
      } catch (e) {
        print('Excepción: $e');
      } finally {
        setState(() {
          cargandoComentarios = false;
        });
      }
    }
  }

  Future<void> _enviarComentario() async {
    print('ID del anime al enviar el comentario: ${widget.animeId}');

    if (_formKey.currentState!.validate()) {
      try {
        // Obtener la ubicación actual
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
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
      }
    }
  }

  Future<void> _listarComentarios() async {
    try {
      FacadeService servicio = FacadeService();
      var response = await servicio.listarComentarios(
        widget.animeId,
        pagina: paginaActual,
        cantidad: comentariosPorPagina,
      );

      if (response.code == 200) {
        setState(() {
          comentarios = List<Map<String, dynamic>>.from(response.datos);
        });
      } else {
        print('Error: ${response.msg}');
      }
    } catch (e) {
      print('Excepción: $e');
    }
  }
}
