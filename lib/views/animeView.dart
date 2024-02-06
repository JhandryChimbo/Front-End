import 'package:flutter/material.dart';
import 'package:noticias/controls/servicio_back/FacadeService.dart';
import 'package:noticias/views/comentarioView.dart';
import 'package:noticias/views/mapComentarioView.dart';
import 'package:noticias/widgets/drawer.dart';

class AnimeView extends StatefulWidget {
  const AnimeView({Key? key}) : super(key: key);

  @override
  _AnimeViewState createState() => _AnimeViewState();
}

class _AnimeViewState extends State<AnimeView> {
  List<Map<String, dynamic>> animes = [];
  // List<String> nombresDeImagenes = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Animes'),
      ),
      drawer: AppDrawer(),
      body: Container(
        // decoration: const BoxDecoration(
        //   gradient: LinearGradient(
        //     begin: Alignment.topLeft,
        //     end: Alignment.bottomRight,
        //     colors: [Colors.blue, Colors.purple],
        //   ),
        // ),
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
    return Card(
      elevation: 5,
      shadowColor: Colors.grey,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: InkWell(
        onTap: () {},
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 200,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                    'http://10.20.137.206:3000/api/images/${anime['archivo']}',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                  Text('Cuerpo: ${anime['cuerpo']}'),
                  Text('Tipo de Anime: ${anime['tipo_anime']}'),
                  Text('Fecha Estreno: ${anime['fecha']}'),
                  Text(
                    'Estado: ${anime['estado']}',
                    style: const TextStyle(color: Colors.green),
                  ),
                  Text(
                    'Autor: ${anime['persona']['nombres']} ${anime['persona']['apellidos']}',
                    style: const TextStyle(
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 10),
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
                  ElevatedButton(
                    onPressed: () {
                      if (anime['id'] != null) {
                        print('ID del anime seleccionado: ${anime['id']}');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MapComentarioView(
                                animeId: anime['id'].toString()),
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
    // _listarNombresDeImagenes();
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
