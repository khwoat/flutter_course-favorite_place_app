import 'package:favorite_place_app/models/place.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class YourPlacesNotifier extends StateNotifier<List<Place>> {
  YourPlacesNotifier() : super(const []);

  void addNewPlace(Place newPlace) {
    state = [newPlace, ...state];
  }
}

final yourPlacesProvider =
    StateNotifierProvider<YourPlacesNotifier, List<Place>>(
        (ref) => YourPlacesNotifier());
