import 'dart:convert';

import 'package:favorite_place_app/models/geocoding_response.dart';
import 'package:favorite_place_app/models/place.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

const apiKey = 'AIzaSyDSs_J0jP5C6GASKvQo0rMy6AoV2c6h78w';

const mapApiHost = 'https://maps.googleapis.com/maps/api';

/// For Network Image
String locationImageUrl(PlaceLocation location) {
  final lat = location.latitude;
  final lng = location.longitude;
  return '$mapApiHost/staticmap?center=$lat,$lng&zoom=13&size=600x300&maptype=roadmap&markers=color:red%7Clabel:A%7C$lat,$lng&key=$apiKey';
}

Future<GeocodingResponseData> getGeocodingData(
  LocationData locationData,
) async {
  final lat = locationData.latitude ?? 0.0;
  final lng = locationData.longitude ?? 0.0;

  final params = '?address=$lat,$lng&key=$apiKey';
  final url = Uri.parse('$mapApiHost/geocode/json$params');

  final response = await http.get(url);
  return GeocodingResponseData.fromJson(jsonDecode(response.body));
}
