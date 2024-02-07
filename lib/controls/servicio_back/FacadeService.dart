import 'dart:convert';

import 'package:noticias/controls/Conexion.dart';
import 'package:noticias/controls/servicio_back/RespuestaGenerica.dart';
import 'package:noticias/controls/servicio_back/modelo/InicioSesionSW.dart';
import 'package:noticias/controls/servicio_back/modelo/CrearUsuarioSW.dart';
import 'package:http/http.dart' as http;

class FacadeService {
  Conexion c = Conexion();
  Future<InicioSesionSW> inicioSesion(Map<String, String> mapa) async {
    Map<String, String> header = {'Content-Type': 'application/json'};
    final String url = '${c.URL}login';
    final uri = Uri.parse(url);
    InicioSesionSW isw = InicioSesionSW();
    try {
      final response =
          await http.post(uri, headers: header, body: jsonEncode(mapa));
      if (response.statusCode != 200) {
        if (response.statusCode == 404) {
          isw.code = 404;
          isw.msg = "Error";
          isw.tag = "Recurso no encontrado";
          isw.datos = {};
        } else {
          Map<dynamic, dynamic> mapa = jsonDecode(response.body);
          isw.code = mapa['code'];
          isw.msg = mapa['msg'];
          isw.tag = mapa['tag'];
          isw.datos = mapa['datos'];
        }
      } else {
        Map<dynamic, dynamic> mapa = jsonDecode(response.body);
        isw.code = mapa['code'];
        isw.msg = mapa['msg'];
        isw.tag = mapa['tag'];
        isw.datos = mapa['datos'];
      }
    } catch (e) {
      isw.code = 500;
      isw.msg = "Error";
      isw.tag = "Error Inesperado";
      isw.datos = {};
    }
    return isw;
  }

  Future<CrearUsuarioSW> crearCuentaUsuario(Map<String, String> mapa) async {
    Map<String, String> header = {'Content-Type': 'application/json'};
    final String url = '${c.URL}admin/persona/usuario/save';
    final uri = Uri.parse(url);
    CrearUsuarioSW isw = CrearUsuarioSW();

    try {
      final response =
          await http.post(uri, headers: header, body: jsonEncode(mapa));

      Map<dynamic, dynamic> mapaRespuesta = jsonDecode(response.body);

      isw.code = mapaRespuesta['code'];
      isw.msg = mapaRespuesta['msg'];
      isw.tag = mapaRespuesta['tag'];
      isw.datos = mapaRespuesta['datos'];
    } catch (e) {
      isw.code = 500;
      isw.msg = "Error";
      isw.tag = "Error Inesperado";
      isw.datos = {};
    }

    return isw;
  }

  Future<RespuestaGenerica> enviarComentario(
    Map<String, dynamic> mapa,
  ) async {
    return await c.solicitudPost('comentarios/save', false, mapa);
  }

  Future<RespuestaGenerica> listarAnimes() async {
    return await c.solicitudGet('animes', false);
  }

  // Future<RespuestaGenerica> listarComentarios() async {
  //   return await c.solicitudGet('comentarios', false);
  // }

  Future<RespuestaGenerica> listarComentarios() async {
    return await c.solicitudGet('comentarios', false);
  }

  Future<RespuestaGenerica> listarUsuarios() async {
    return await c.solicitudGet('admin/personas', false);
  }

  Future<RespuestaGenerica> modificarUsuario(
      Map<dynamic, dynamic> data, String idPersona) async {
    return await c.solicitudPut(
        'personas/modificar/usuario/$idPersona', false, data);
  }

  Future<RespuestaGenerica> modificarComentario(
      Map<dynamic, dynamic> data, String idComentario) async {
    return await c.solicitudPut(
        'comentarios/modificar/$idComentario', false, data);
  }

  Future<RespuestaGenerica> banearUsuario(String idPersona) async {
    return await c.solicitudPutVoid('admin/personas/banear/$idPersona', false);
  }

  Future<RespuestaGenerica> obtenerUsuario(String idPersona) async {
    return await c.solicitudGet('admin/personas/get/$idPersona', false);
  }

  // Future<RespuestaGenerica> obtenerAnime(String idAnime) async {
  //   return await c.solicitudGet('animes/get/$idAnime', false);
  // }

  Future<List<String>> obtenerNombresDeImagenes() async {
    try {
      var respuesta = await c.solicitudGet('images/', false);

      var datos = respuesta.datos;

      if (datos is String) {
        try {
          var jsonData = json.decode(datos);
          if (jsonData is List) {
            List<String> nombresDeImagenes =
                jsonData.map((imagen) => imagen.toString()).toList();
            return nombresDeImagenes;
          }
        } catch (e) {
          print('Error al decodificar JSON: $e');
        }
      }
      return [];
    } catch (error) {
      print('Error al obtener nombres de imágenes: $error');
      return [];
    }
  }

  Future<RespuestaGenerica> guardarComentario(
      Map<dynamic, dynamic> data) async {
    return await c.solicitudPost('comentarios/save', false, data);
  }
}
