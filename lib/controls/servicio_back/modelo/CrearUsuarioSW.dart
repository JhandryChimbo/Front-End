import 'package:noticias/controls/servicio_back/RespuestaGenerica.dart';

class CrearUsuarioSW extends RespuestaGenerica {
  String tag = '';
  CrearUsuarioSW({msg = "", code = 0, datos, this.tag = ''});
}
