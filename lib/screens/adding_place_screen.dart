import 'dart:io';

import 'package:favorite_place_app/models/place.dart';
import 'package:favorite_place_app/providers/your_places_provider.dart';
import 'package:favorite_place_app/widgets/image_input.dart';
import 'package:favorite_place_app/widgets/location_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddingPlaceScreen extends ConsumerStatefulWidget {
  const AddingPlaceScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _AddingPlaceScreenState();
  }
}

class _AddingPlaceScreenState extends ConsumerState<AddingPlaceScreen> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  File? _selectedImage;
  PlaceLocation? _selectedLocation;

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _addPlace() {
    if (_formKey.currentState!.validate() &&
        _selectedImage != null &&
        _selectedLocation != null) {
      ref.read(yourPlacesProvider.notifier).addNewPlace(
            _titleController.text.trim(),
            _selectedImage!,
            _selectedLocation!,
          );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Place'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 24,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Textfield of TITLE
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  label: Text('Title'),
                ),
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Colors.white,
                    ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter this field.';
                  }
                  if (value.length < 6 || value.length > 30) {
                    return 'Length should be between 6 to 30 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),

              //Image input
              ImageInput(
                onSelectImage: (image) {
                  _selectedImage = image;
                },
              ),
              const SizedBox(height: 10),

              LocationInput(
                onSelectLocation: (location) {
                  _selectedLocation = location;
                },
              ),
              const SizedBox(height: 16),

              // Add a new place button
              ElevatedButton.icon(
                onPressed: _addPlace,
                icon: const Icon(Icons.add),
                label: const Text('Add place'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
