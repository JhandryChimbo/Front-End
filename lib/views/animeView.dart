import 'package:flutter/material.dart';
import 'package:noticias/controls/servicio_back/FacadeService.dart';
import 'package:noticias/controls/utiles/Utiles.dart';
import 'package:noticias/views/comentarioView.dart';
import 'package:noticias/views/mapComentarioView.dart';
import 'package:noticias/widgets/drawer.dart';

class AnimeView extends StatefulWidget {
  const AnimeView({super.key});

  @override
  _AnimeViewState createState() => _AnimeViewState();
}

class _AnimeViewState extends State<AnimeView> {
  List<Map<String, dynamic>> animes = [];
  Map<String, dynamic> usuario = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Animes'),
      ),
      drawer: AppDrawer(),
      body: Container(
        child: _buildAnimeList(),
      ),
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
    bool esAdmin = usuario.containsKey('rol') &&
        usuario['rol'] != null &&
        usuario['rol']['nombre'] == 'admin';

    return Card(
      elevation: 5,
      shadowColor: Colors.grey,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: InkWell(
        onTap: () {
          if (anime['id'] != null) {
            print('ID del anime seleccionado: ${anime['id']}');
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ComentarioAnimeView(
                  animeId: anime['id'].toString(),
                  animeTitulo: anime['titulo'],
                  animeCuerpo: anime['cuerpo'],
                  animeFecha: anime['fecha'],
                ),
              ),
            );
          } else {
            print('La propiedad "id" es nula en este anime.');
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 200,
              decoration: BoxDecoration(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(10.0)),
                image: DecorationImage(
                  image: NetworkImage(
                    'http://192.168.0.105:3000/api/images/${anime['archivo']}',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Center(
                    child: Text(
                      anime['titulo'],
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text('${anime['cuerpo']}',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[800],
                      ),
                      textAlign: TextAlign.justify),
                  const SizedBox(height: 8),
                  Text(
                    'Tipo de Anime: ${anime['tipo_anime']}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Fecha de Estreno: ${anime['fecha']}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Autor: ${anime['persona']['nombres']} ${anime['persona']['apellidos']}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          if (anime['id'] != null) {
                            print('ID del anime seleccionado: ${anime['id']}');
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ComentarioAnimeView(
                                  animeId: anime['id'].toString(),
                                  animeTitulo: anime['titulo'],
                                  animeCuerpo: anime['cuerpo'],
                                  animeFecha: anime['fecha'],
                                ),
                              ),
                            );
                          } else {
                            print('La propiedad "id" es nula en este anime.');
                          }
                        },
                        child: const Text('Comentar'),
                      ),
                      if (esAdmin)
                        ElevatedButton(
                          onPressed: () {
                            if (anime['id'] != null) {
                              print(
                                  'ID del anime seleccionado: ${anime['id']}');
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MapComentarioView(
                                    animeId: anime['id'].toString(),
                                  ),
                                ),
                              );
                            } else {
                              print('La propiedad "id" es nula en este anime.');
                            }
                          },
                          child: const Text('Mapa'),
                        ),
                    ],
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
    _listarAnimes();
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
}
