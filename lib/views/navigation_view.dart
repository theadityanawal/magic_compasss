import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import '../services/navigation_service.dart';
import '../services/calibration_service.dart';
import 'calibration_view.dart';
import 'location_selection_view.dart';
import '../models/location.dart';
import 'dart:math';


class NavigationView extends StatefulWidget {
  final NavigationService navigationService;
  final CalibrationService calibrationService;

  NavigationView({required this.navigationService, required this.calibrationService});

  @override
  _NavigationViewState createState() => _NavigationViewState();
}

class _NavigationViewState extends State<NavigationView> {
  double _direction = 0;
  bool _isNavigating = false;

  @override
  void initState() {
    super.initState();
    FlutterCompass.events?.listen((CompassEvent event) {
      setState(() {
        _direction = event.heading ?? _direction;
      });
    });
  }

    double _calculateDirection() {
    Location? currentLocation = widget.navigationService.getCurrentLocation();
    Location? destination = widget.navigationService.getDestination();

    if (currentLocation != null && destination != null) {
      double dx = destination.x - currentLocation.x;
      double dy = destination.y - currentLocation.y;
      return atan2(dy, dx) * (180 / pi);
    } else {
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Magic Compass'),
        backgroundColor: Colors.blueGrey,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Current Location: ${widget.navigationService.getCurrentLocation()?.name ?? 'Unknown'}',
              style: TextStyle(fontSize: 20),
            ),
            Text(
              'Destination: ${widget.navigationService.getDestination()?.name ?? 'None'}',
              style: TextStyle(fontSize: 20),
            ),
            Transform.rotate(
              angle: ((_direction) * (3.14159 / 180) * -1),
              child: Image.asset('assets/compass.png'),
            ),
            ElevatedButton(
              child: Text(_isNavigating ? 'Stop Navigation' : 'Start Navigation'),
              onPressed: () {
                setState(() {
                  _isNavigating = !_isNavigating;
                  if (_isNavigating) {
                    widget.navigationService.startNavigation();
                  } else {
                    widget.navigationService.stopNavigation();
                  }
                });
              },
            ),
            ElevatedButton(
              child: Text('Calibrate'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CalibrationView(calibrationService: widget.calibrationService, navigationService: widget.navigationService)),
                );
              },
            ),
            ElevatedButton(
              child: Text('Select Destination'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LocationSelectionView(navigationService: widget.navigationService)),
                );
              },
            ),
          ],
        ),
      ), 
    );
  }
}
