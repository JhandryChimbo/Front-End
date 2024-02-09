import 'dart:convert';

import 'package:noticias/controls/Conexion.dart';
import 'package:noticias/controls/servicio_back/RespuestaGenerica.dart';
import 'package:noticias/controls/servicio_back/modelo/InicioSesionSW.dart';
import 'package:noticias/controls/servicio_back/modelo/CrearUsuarioSW.dart';
import 'package:http/http.dart' as http;

class FacadeService {
  Conexion c = Conexion();
  // Inicio de sesion
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

  // Registro de usuario
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

  // Listar animes
  Future<RespuestaGenerica> listarAnimes() async {
    return await c.solicitudGet('animes', true);
  }

  // Listar comentarios
  Future<RespuestaGenerica> listarComentarios() async {
    return await c.solicitudGet('comentarios', true);
  }

  // Listar usuarios
  Future<RespuestaGenerica> listarUsuarios() async {
    return await c.solicitudGet('admin/personas', true);
  }

  // Modificar Usuario
  Future<RespuestaGenerica> modificarUsuario(
      Map<dynamic, dynamic> data, String idPersona) async {
    return await c.solicitudPut(
        'personas/modificar/usuario/$idPersona', true, data);
  }

  // Modificar Comentario
  Future<RespuestaGenerica> modificarComentario(
      Map<dynamic, dynamic> data, String idComentario) async {
    return await c.solicitudPut(
        'comentarios/modificar/$idComentario', true, data);
  }

  // Banear/Desbanear Usuario
  Future<RespuestaGenerica> modificarEstadoUsuario(
      String idPersona, Map<dynamic, dynamic> data) async {
    return await c.solicitudPut('admin/personas/banear/$idPersona', true, data);
  }

  // Obtener Usuario
  Future<RespuestaGenerica> obtenerUsuario(String idPersona) async {
    return await c.solicitudGet('admin/personas/get/$idPersona', true);
  }

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

  // Guardar comentario
  Future<RespuestaGenerica> enviarComentario(
    Map<String, dynamic> mapa,
  ) async {
    return await c.solicitudPost('comentarios/save', true, mapa);
  }
}
