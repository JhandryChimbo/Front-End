import 'package:flutter/material.dart';
import 'package:noticias/controls/servicio_back/FacadeService.dart';
import 'package:noticias/widgets/drawer.dart';
import 'package:geolocator/geolocator.dart';

class AnimeView extends StatefulWidget {
  const AnimeView({Key? key}) : super(key: key);

  @override
  _AnimeViewState createState() => _AnimeViewState();
}

class _AnimeViewState extends State<AnimeView> {
  List<Map<String, dynamic>> animes = [];
  List<String> nombresDeImagenes = [];
  late Position ubicacionActual;
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Animes'),
      ),
      drawer: AppDrawer(),
      body: _buildAnimeList(),
    );
  }

  Widget _buildAnimeList() {
    List<Map<String, dynamic>> animesActivos =
        animes.where((anime) => anime['estado'] == true).toList();

    if (animesActivos.isEmpty) {
      return const Center(child: Text('No hay animes activos.'));
    } else {
      return ListView.separated(
        itemCount: animesActivos.length,
        separatorBuilder: (context, index) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          var anime = animesActivos[index];
          return _buildAnimeCard(anime);
        },
      );
    }
  }

  Widget _buildAnimeCard(Map<String, dynamic> anime) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: InkWell(
        onTap: () {
          // Acción al tocar la tarjeta (si es necesario).
        },
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                anime['titulo'],
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Text('Cuerpo: ${anime['cuerpo']}'),
              Text('Tipo de Anime: ${anime['tipo_anime']}'),
              Text('Fecha Estreno: ${anime['fecha']}'),
              Text('Archivo: ${anime['archivo']}'),
              Text(
                'Estado: ${anime['estado']}',
                style: TextStyle(
                  color: anime['estado'] ? Colors.green : Colors.red,
                ),
              ),
              Text(
                'Autor: ${anime['persona']['nombres']} ${anime['persona']['apellidos']}',
                style: const TextStyle(
                  fontStyle: FontStyle.italic,
                ),
              ),
              // Mostrar las imágenes basadas en la lista de nombres
              _buildImages(anime['archivo']), // Pasar el nombre de la imagen
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  if (anime['id'] != null) {
                    _comentarAnime(anime['id'].toString());
                    Navigator.pushReplacementNamed(context, '/comentario');
                  } else {
                    print('La propiedad "id" es nula en este anime.');
                  }
                },
                child: const Text('Comentar'),
              ),
              ElevatedButton(
                  onPressed: () {
                    _obtenerUbicacionActual();
                  },
                  child: const Text('Obtener Ubicación'),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImages(String nombreDeImagen) {
    // Construir la URL completa de la imagen
    String imageUrl = 'http://192.168.0.105:3000/api/images/$nombreDeImagen';

    return Image.network(
      imageUrl,
      height: 100,
      width: 100,
      fit: BoxFit.cover,
    );
  }

  void _comentarAnime(String animeId) {
    // Implementar la lógica para manejar la acción de comentario del anime
    print('Comentario del anime con ID: $animeId');
    // Puedes abrir un nuevo cuadro de diálogo, navegar a una nueva pantalla, etc.
  }

  @override
  void initState() {
    super.initState();
    _listarAnimes();
    _listarNombresDeImagenes();
  }

  void _obtenerUbicacionActual() async {
    try {
      // Verificar si se tienen permisos de ubicación
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        // Si no hay permisos, solicitarlos
        permission = await Geolocator.requestPermission();
        if (permission != LocationPermission.whileInUse &&
            permission != LocationPermission.always) {
          // El usuario no otorgó permisos, manejar según tus necesidades
          
          return;
        }
      }

      // Obtener la ubicación actual
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      setState(() {
        ubicacionActual = position;
      });

      // Mostrar la ubicación en la consola (puedes utilizarla como desees)
      print('Ubicación Actual: ${position.latitude}, ${position.longitude}');
    } catch (e) {
      print('Error al obtener la ubicación: $e');
    }
  }

  Future<void> _listarAnimes() async {
    try {
      FacadeService servicio = FacadeService();
      var response = await servicio.listarAnimes();

      if (response.code == 200) {
        setState(() {
          animes = List<Map<String, dynamic>>.from(response.datos);
        });
      } else {
        print('Error: ${response.msg}');
      }
    } catch (e) {
      print('Excepción: $e');
    }
  }

  Future<void> _listarNombresDeImagenes() async {
    try {
      // Llamada a la función para obtener los nombres de imágenes
      FacadeService servicio = FacadeService();
      List<String> nombres = await servicio.obtenerNombresDeImagenes();

      setState(() {
        nombresDeImagenes = nombres;
      });
    } catch (e) {
      print('Error al obtener nombres de imágenes: $e');
    }
  }
}
