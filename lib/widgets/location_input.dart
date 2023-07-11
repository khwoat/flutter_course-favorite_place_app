import 'dart:convert';

import 'package:favorite_place_app/constants/api.dart';
import 'package:favorite_place_app/models/place.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';

import 'package:http/http.dart' as http;

class LocationInput extends StatefulWidget {
  const LocationInput({
    super.key,
    required this.onSelectLocation,
  });

  final void Function(PlaceLocation location) onSelectLocation;

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  PlaceLocation? _pickedLocation;
  bool _isGettingLocation = false;

  void _getCurrentLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData? locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    setState(() {
      _isGettingLocation = true;
    });

    locationData = await location.getLocation();

    final lat = locationData.latitude ?? 0.0;
    final lng = locationData.longitude ?? 0.0;
    final url = Uri.parse(geoCodeUrl(locationData));

    final response = await http.get(url);
    final resData = jsonDecode(response.body);

    final address = resData['results'][0]['formatted_address'];

    setState(() {
      _pickedLocation = PlaceLocation(
        latitude: lat,
        longtitude: lng,
        address: address,
      );
      _isGettingLocation = false;
    });

    widget.onSelectLocation(_pickedLocation!);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _PreviewMap(
          placeLocation: _pickedLocation,
          isGettingLocation: _isGettingLocation,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(
              onPressed: _getCurrentLocation,
              icon: const Icon(Icons.location_on),
              label: const Text('Get current location'),
            ),
            TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.map),
              label: const Text('Pick on map'),
            ),
          ],
        )
      ],
    );
  }
}

class _PreviewMap extends StatelessWidget {
  const _PreviewMap({
    required this.placeLocation,
    required this.isGettingLocation,
  });

  final PlaceLocation? placeLocation;
  final bool isGettingLocation;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 170,
      width: double.infinity,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(
          width: 2,
          color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
        ),
      ),
      child: (isGettingLocation)
          ? const CircularProgressIndicator()
          : (placeLocation != null)
              ? Image.network(
                  locationImageUrl(placeLocation!),
                  fit: BoxFit.cover,
                  height: double.infinity,
                  width: double.infinity,
                )
              : Text(
                  'No location chosen',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                ),
    );
  }
}
