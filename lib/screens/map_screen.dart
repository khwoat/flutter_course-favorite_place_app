import 'package:favorite_place_app/apis/google_map_api.dart';
import 'package:favorite_place_app/models/place.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({
    super.key,
    this.location = const PlaceLocation(
      latitude: 13.736717,
      longitude: 100.523186,
      address: '',
    ),
    this.isSelecting = true,
    this.onSelectLocation,
  });

  final PlaceLocation location;
  final bool isSelecting;
  final void Function(LatLng latLng, String address)? onSelectLocation;

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? _pickedLocation;

  void _saveLocation() async {
    if (_pickedLocation != null) {
      final geocodingData = await getGeocodingData(LocationData.fromMap({
        'latitude': _pickedLocation!.latitude,
        'longitude': _pickedLocation!.longitude,
      }));
      widget.onSelectLocation!(
        _pickedLocation!,
        geocodingData.results.first.formattedAddress,
      );
    }

    if (context.mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  void initState() {
    if (!widget.isSelecting && widget.onSelectLocation != null) {
      throw Exception(
        'Unhandled Erorr: Function onSelectLocation wasn\'t null while isSelecting is false.',
      );
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.isSelecting ? 'Pick your location' : 'Your location'),
        actions: [
          if (widget.isSelecting && widget.onSelectLocation != null)
            IconButton(
              onPressed: _saveLocation,
              icon: const Icon(Icons.save),
            ),
        ],
      ),
      body: GoogleMap(
        onTap: widget.isSelecting
            ? (latLng) {
                setState(() {
                  _pickedLocation = latLng;
                });
              }
            : null,
        initialCameraPosition: CameraPosition(
          target: LatLng(
            widget.location.latitude,
            widget.location.longitude,
          ),
          zoom: 16,
        ),
        markers: (_pickedLocation == null && widget.isSelecting)
            ? {}
            : {
                Marker(
                  markerId: const MarkerId('m1'),
                  position: _pickedLocation ??
                      LatLng(
                        widget.location.latitude,
                        widget.location.longitude,
                      ),
                  onTap: () {
                    print('CLicked');
                  },
                ),
              },
      ),
    );
  }
}
