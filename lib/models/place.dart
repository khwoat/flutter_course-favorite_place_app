import 'dart:io';

import 'package:uuid/uuid.dart';

const uuid = Uuid();

class Place {
  Place({
    required this.title,
    required this.image,
    required this.location,
  }) : id = uuid.v4();

  final String id;
  final String title;
  final File image;
  final PlaceLocation location;

  Place.fromDbQueryData(Map<String, Object?> queryData)
      : id = queryData['id'] as String,
        title = queryData['title'] as String,
        image = File(queryData['image'] as String),
        location = PlaceLocation(
          latitude: queryData['lat'] as double,
          longitude: queryData['lng'] as double,
          address: queryData['address'] as String,
        );

  Map<String, dynamic> toDbJson() {
    Map<String, dynamic> map = {};
    map['id'] = id;
    map['title'] = title;
    map['image'] = image.path;
    map['lat'] = location.latitude;
    map['lng'] = location.longitude;
    map['address'] = location.address;
    return map;
  }
}

class PlaceLocation {
  const PlaceLocation({
    required this.latitude,
    required this.longitude,
    required this.address,
  });

  final double latitude;
  final double longitude;
  final String address;
}
