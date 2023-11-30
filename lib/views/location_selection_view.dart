// location_selection_view.dart
import 'package:flutter/material.dart';
import '../services/navigation_service.dart';
import '../main.dart';

class LocationSelectionView extends StatefulWidget {
  final NavigationService navigationService;

  LocationSelectionView({required this.navigationService});

  @override
  _LocationSelectionViewState createState() => _LocationSelectionViewState();
}

class _LocationSelectionViewState extends State<LocationSelectionView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Location'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: ListView.builder(
        itemCount: locations.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              leading: Icon(Icons.location_on),
              title: Text(locations[index].name, style: TextStyle(fontSize: 20)),
              onTap: () {
                // Check if the current location is being selected
                if (widget.navigationService.isSelectingCurrentLocation()) {
                  widget.navigationService.setCurrentLocation(locations[index]);
                } else {
                  widget.navigationService.setDestination(locations[index]);
                }
                Navigator.pop(context);
              },
            ),
          );
        },
      ),
    );
  }
}
