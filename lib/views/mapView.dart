import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:noticias/widgets/drawer.dart';
import 'package:geolocator/geolocator.dart';
import 'package:noticias/controls/servicio_back/FacadeService.dart';

const mapbox_access_token =
    'pk.eyJ1IjoiamhhbmRyeS1jaGltYm8iLCJhIjoiY2xzNnB0OHd5MHRtbjJqbXJrMHpkeGZ4MCJ9.r1HKgPunHG6XaBDrmuKLpw';

class MapView extends StatefulWidget {
  const MapView({Key? key}) : super(key: key);

  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  late LatLng myPosition = const LatLng(0, 0);

  List<Map<String, dynamic>> comentarios = [];

  @override
  void initState() {
    super.initState();
    _initializeLocation();
  }

  Future<void> _initializeLocation() async {
    await _obtenerUbicacionActual();
    _listarComentarios();
  }

  Future<void> _obtenerUbicacionActual() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
      );

      setState(() {
        myPosition = LatLng(position.latitude, position.longitude);
      });
    } catch (e) {
      print('Excepción al obtener la ubicación: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa'),
      ),
      drawer: AppDrawer(),
      body: myPosition != const LatLng(0, 0) ? _buildMapa() : _buildLoading(),
    );
  }

  Widget _buildMapa() {
    return FlutterMap(
      options: MapOptions(
        initialCenter: myPosition,
        minZoom: 5,
        maxZoom: 100,
        initialZoom: 18,
      ),
      children: [
        TileLayer(
          maxZoom: 19,
          urlTemplate:
              'https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token={accessToken}',
          additionalOptions: const {
            'accessToken': mapbox_access_token,
            'id': 'mapbox/streets-v12'
          },
        ),
        MarkerLayer(
          markers: [
            Marker(
              point: myPosition,
              width: 80,
              height: 80,
              child: const Icon(
                Icons.person_pin_circle,
                color: Colors.green,
                size: 40,
              ),
            ),
            ...comentarios.map(
              (comentario) => Marker(
                point: LatLng(
                  comentario['latitud'] ?? 0.0,
                  comentario['longitud'] ?? 0.0,
                ),
                width: 80,
                height: 80,
                child: const Icon(
                  Icons.pin_drop,
                  color: Colors.blue,
                  size: 40,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLoading() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Future<void> _listarComentarios() async {
    try {
      FacadeService servicio = FacadeService();
      var response = await servicio.listarComentariosMapa();

      if (response.code == 200) {
        setState(() {
          comentarios = List<Map<String, dynamic>>.from(response.datos);
        });
      } else {
        print('Error: ${response.msg}');
      }
    } catch (e) {
      print('Excepción al listar comentarios: $e');
    }
  }
}
