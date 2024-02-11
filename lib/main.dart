import 'package:flutter/material.dart';
import 'package:noticias/views/animeView.dart';
import 'package:noticias/views/exception/Page404.dart';
import 'package:noticias/views/mapView.dart';
import 'package:noticias/views/registerView.dart';
import 'package:noticias/views/sessionView.dart';
import 'package:noticias/views/comentarioView.dart';
import 'package:noticias/views/mapComentarioView.dart';
import 'package:noticias/views/userListView.dart';
import 'package:noticias/views/userProfileView.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 16, 52, 194)),
        useMaterial3: true,
      ),
      home: const SessionView(),
      initialRoute: '/home',
      //TODAS LAS PANTALLAS QUE PONGA AQUI SE VAN A IR REGISTRANDO
      routes: {
        '/home': (context) => const SessionView(),
        '/register': (context) => const RegisterView(),
        '/animes': (context) => const AnimeView(),
        '/usuarios': (context) => const UserListView(),
        '/map': (context) => const MapView(),
        '/mapComment': (context) => const MapComentarioView(
              animeId: '',
            ),
        '/profile': (context) => const UserProfileView(),
        '/comentario': (context) => const ComentarioAnimeView(
              animeId: '',
              animeTitulo: '',
              animeCuerpo: '',
              animeFecha: '',
            ),
      },
      onGenerateRoute: (settings) {
        return MaterialPageRoute(builder: (context) => const Page404());
      },
    );
  }
}
