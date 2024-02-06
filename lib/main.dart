import 'package:flutter/material.dart';
import 'package:noticias/views/animeView.dart';
import 'package:noticias/views/exception/Page404.dart';
import 'package:noticias/views/mapView.dart';
import 'package:noticias/views/registerView.dart';
import 'package:noticias/views/sessionView.dart';
import 'package:noticias/views/comentarioView.dart';
import 'package:noticias/views/mapComentarioView.dart';

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
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.

        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
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
        '/map': (context) => const MapView(),
        '/mapComment': (context) => const MapComentarioView(animeId: '',),
        '/profile': (context) => const MapView(),
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
