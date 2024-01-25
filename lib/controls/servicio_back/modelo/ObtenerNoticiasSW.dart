import 'package:noticias/controls/servicio_back/RespuestaGenerica.dart';

class ObtenerNoticiasSW extends RespuestaGenerica {
  String tag = '';
  ObtenerNoticiasSW({msg = "", code = 0, datos, this.tag = ''});
}