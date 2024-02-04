import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:noticias/widgets/drawer.dart';

const mapbox_access_token =
    'pk.eyJ1IjoiamhhbmRyeS1jaGltYm8iLCJhIjoiY2xzNnB0OHd5MHRtbjJqbXJrMHpkeGZ4MCJ9.r1HKgPunHG6XaBDrmuKLpw';

const myPosition = LatLng(-4.0263645, -79.2055705);

class MapaView extends StatefulWidget {
  const MapaView({Key? key}) : super(key: key);

  @override
  _MapaViewState createState() => _MapaViewState();
}

class _MapaViewState extends State<MapaView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa'),
      ),
      drawer: AppDrawer(),
      body: _buildMapa(),
    );
  }

  Widget _buildMapa() {
    return FlutterMap(
      options: const MapOptions(
        initialCenter: myPosition,
        minZoom: 5,
        maxZoom: 100,
        initialZoom: 18,
      ),
      children: [
        TileLayer(
          maxNativeZoom: 19,
          urlTemplate:
              'https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token={accessToken}',
          additionalOptions: const {
            'accessToken': mapbox_access_token,
            'id': 'mapbox/dark-v11'
          },
        ),
        const MarkerLayer(
          markers: [
            Marker(
              point: LatLng(-4.0263645, -79.2055705),
              width: 80,
              height: 80,
              child: Icon(
                Icons.person_pin,
                color: Colors.blueAccent,
                size: 40,
              ),
            ),
          ],
        ),
      ],
    );
  }
}