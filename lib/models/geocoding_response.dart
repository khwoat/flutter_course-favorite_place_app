import 'package:google_maps_flutter/google_maps_flutter.dart';

class GeocodingResponseData {
  const GeocodingResponseData({
    required this.results,
    required this.status,
  });

  final List<GeocodingResult> results;
  final String status;

  GeocodingResponseData.fromJson(dynamic json)
      : results = (json['results'] as List)
            .map((result) => GeocodingResult.fromJson(result))
            .toList(),
        status = json['status'];
}

class GeocodingResult {
  const GeocodingResult({
    required this.addressComponents,
    required this.formattedAddress,
    required this.geometries,
    required this.placeId,
    required this.plusCodes,
    required this.types,
  });

  final List<AddressComponent> addressComponents;
  final String formattedAddress;
  final Geometry geometries;
  final String placeId;
  final Map<String, String>? plusCodes;
  final List<String> types;

  GeocodingResult.fromJson(dynamic json)
      : addressComponents = (json['address_components'] as List)
            .map((addrComponent) => AddressComponent.fromJson(addrComponent))
            .toList(),
        formattedAddress = json['formatted_address'] ?? 'Unknown Address',
        geometries = Geometry.fromJson(json['geometry']),
        placeId = json['place_id'] ?? 'NO_ID',
        types = (json['types'] as List).map<String>((e) => e).toList(),
        plusCodes = (json['plus_code'] as Map<String, dynamic>?)
            ?.map<String, String>((key, value) => MapEntry(key, value));
}

class AddressComponent {
  const AddressComponent({
    required this.longName,
    required this.shortName,
    required this.types,
  });

  final String longName;
  final String shortName;
  final List<String> types;

  AddressComponent.fromJson(dynamic json)
      : longName = json['long_name'] ?? 'Unknown Long Name',
        shortName = json['short_name'] ?? 'Unknown Short Name',
        types = (json['types'] as List).map<String>((e) => e).toList();
}

class Geometry {
  const Geometry({
    required this.location,
    required this.locationType,
    required this.viewports,
  });

  final LatLng location;
  final String locationType;
  final Map<String, LatLng> viewports;

  Geometry.fromJson(dynamic json)
      : location = LatLng(json['location']['lat'], json['location']['lng']),
        locationType = json['location_type'] ?? 'NO_LOCATION_TYPE',
        viewports = (json['viewport'] as Map<String, dynamic>)
            .map<String, LatLng>((key, value) => MapEntry(
                  key,
                  LatLng(value['lat'] ?? 0.0, value['lng'] ?? 0.0),
                ));
}
