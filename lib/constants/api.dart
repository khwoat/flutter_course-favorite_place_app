import 'package:favorite_place_app/models/place.dart';
import 'package:location/location.dart';

const apiKey = 'AIzaSyDSs_J0jP5C6GASKvQo0rMy6AoV2c6h78w';

const mapApiHost = 'https://maps.googleapis.com/maps/api';

String locationImageUrl(PlaceLocation location) {
  final lat = location.latitude;
  final lng = location.longtitude;
  return '$mapApiHost/staticmap?center=$lat,$lng&zoom=13&size=600x300&maptype=roadmap&markers=color:red%7Clabel:A%7C$lat,$lng&key=$apiKey';
}

String geoCodeUrl(LocationData locationData) {
  final lat = locationData.latitude ?? 0.0;
  final lng = locationData.longitude ?? 0.0;
  return '$mapApiHost/geocode/json?address=$lat,$lng&key=$apiKey';
}
