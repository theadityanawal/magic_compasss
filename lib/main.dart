import 'package:flutter/material.dart';
import './models/location.dart';
import './services/calibration_service.dart';
import './services/navigation_service.dart';
import './views/navigation_view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Magic Compass Indoor Navigation',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  final NavigationService navigationService = NavigationService();
  final CalibrationService calibrationService = CalibrationService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Magic Compass Indoor Navigation'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              child: Text('Start Navigation'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NavigationView(navigationService: navigationService, calibrationService: calibrationService)),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

List<Location> locations = [
  Location(name: 'D311', x: 10.0, y: 20.0),
  Location(name: 'D312', x: 10.0, y: 23.0),
  Location(name: 'D313', x: 10.0, y: 26.0),
  Location(name: 'D314', x: 10.0, y: 29.0),
  Location(name: 'D315', x: 10.0, y: 32.0),
  Location(name: 'D316', x: 10.0, y: 35.0),
  Location(name: 'D317', x: 10.0, y: 38.0),
  Location(name: 'D318', x: 10.0, y: 41.0),
  Location(name: 'D319', x: 20.0, y: 44.0),
  // Add more locations as needed
];
