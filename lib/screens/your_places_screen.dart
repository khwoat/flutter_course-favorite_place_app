import 'package:favorite_place_app/models/place.dart';
import 'package:favorite_place_app/providers/your_places_provider.dart';
import 'package:favorite_place_app/screens/adding_place_screen.dart';
import 'package:favorite_place_app/screens/place_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class YourPlacesScreen extends ConsumerStatefulWidget {
  const YourPlacesScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _YourPlacesScreenState();
}

class _YourPlacesScreenState extends ConsumerState<YourPlacesScreen> {
  late Future<void> placesFuture;

  @override
  void initState() {
    placesFuture = ref.read(yourPlacesProvider.notifier).loadPlaces();
    super.initState();
  }

  void _addPlace(context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const AddingPlaceScreen(),
      ),
    );
  }

  void _pushPlaceDetailScreen(context, Place place) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PlaceDetailScreen(place: place),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final yourPlaces = ref.watch(yourPlacesProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Places'),
        actions: [
          IconButton(
            onPressed: () => _addPlace(context),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: FutureBuilder(
          future: placesFuture,
          builder: (context, snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return (yourPlaces.isNotEmpty)
                ? ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 12,
                    ),
                    itemCount: yourPlaces.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        onTap: () {
                          _pushPlaceDetailScreen(context, yourPlaces[index]);
                        },
                        leading: CircleAvatar(
                          radius: 20,
                          backgroundImage: FileImage(yourPlaces[index].image),
                        ),
                        title: Text(
                          yourPlaces[index].title,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        subtitle: Text(
                          yourPlaces[index].location.address,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                              ),
                        ),
                      );
                    },
                  )
                : Center(
                    child: Text(
                      'No place added yet.',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: Colors.white,
                          ),
                    ),
                  );
          }),
    );
  }
}
