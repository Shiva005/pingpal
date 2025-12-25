import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

import '../theme/app_theme.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  GoogleMapController? _controller;
  LatLng? _currentLatLng;

  static const LatLng center = LatLng(51.5014, -0.1246);

  final List<Map<String, dynamic>> friendLocations = [
    {
      "name": "Emma",
      "position": const LatLng(51.5007, -0.1246), // Big Ben
    },
    {
      "name": "Jacob",
      "position": const LatLng(51.5014, -0.1419), // Buckingham Palace
    },
    {
      "name": "Ava",
      "position": const LatLng(51.5033, -0.1195), // London Eye
    },
  ];

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
  }

  /// 1️⃣ Request permission
  Future<void> _requestLocationPermission() async {
    final status = await Permission.location.request();

    if (status.isGranted) {
      await _getCurrentLocation();
    } else {
      debugPrint("Location permission denied");
    }
  }

  /// 2️⃣ Get current location
  Future<void> _getCurrentLocation() async {
    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      _currentLatLng = LatLng(position.latitude, position.longitude);
    });

    _fitAllMarkers();
  }

  /// 3️⃣ Fit all markers on screen
  void _fitAllMarkers() {
    if (_controller == null || friendLocations.isEmpty) return;

    final points = friendLocations.map((e) => e["position"] as LatLng).toList();

    final bounds = _createBounds(points);

    _controller!.animateCamera(
      CameraUpdate.newLatLngBounds(bounds, 80),
    );
  }

  LatLngBounds _createBounds(List<LatLng> positions) {
    double southLat = positions.first.latitude;
    double northLat = positions.first.latitude;
    double westLng = positions.first.longitude;
    double eastLng = positions.first.longitude;

    for (final p in positions) {
      southLat = southLat < p.latitude ? southLat : p.latitude;
      northLat = northLat > p.latitude ? northLat : p.latitude;
      westLng = westLng < p.longitude ? westLng : p.longitude;
      eastLng = eastLng > p.longitude ? eastLng : p.longitude;
    }

    return LatLngBounds(
      southwest: LatLng(southLat, westLng),
      northeast: LatLng(northLat, eastLng),
    );
  }

  /// 4️⃣ All markers
  Set<Marker> get _markers {
    final markers = friendLocations.map((f) {
      return Marker(
        markerId: MarkerId(f["name"]),
        position: f["position"],
        infoWindow: InfoWindow(title: f["name"]),
      );
    }).toSet();

    return markers;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.cardBackground,
        elevation: 0,
        title: const Text(
          "Live Map",
          style: TextStyle(color: AppTheme.textWhite),
        ),
        centerTitle: true,
      ),
      body: GoogleMap(
        initialCameraPosition:
            const CameraPosition(target: LatLng(0, 0), zoom: 1),
        markers: _markers,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        zoomControlsEnabled: true,
        onMapCreated: (c) {
          _controller = c;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _fitAllMarkers();
          });
        },
      ),
    );
  }
}
