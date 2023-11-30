import '../models/step_detector.dart';
import '../models/orientation_detector.dart';
import '../models/location.dart';
import 'dart:math';

class NavigationService {
  StepDetector _stepDetector = StepDetector();
  OrientationDetector _orientationDetector = OrientationDetector();
  Location? _origin;
  Location? _currentLocation;
  Location? _destination;
  final double _strideLength = 0.75; // You can estimate this value based on the user's height

  void startNavigation({Location? destination}) {
    if (destination != null) {
      _destination = destination;
    }
    _currentLocation ??= Location(name: 'Current Location', x: 0.0, y: 0.0);
    _stepDetector.startListening(onStepDetected: _onStepDetected);
    _orientationDetector.startListening(onOrientationChanged: _onOrientationChanged);
  }

  void stopNavigation() {
    _stepDetector.stopListening();
    _orientationDetector.stopListening();
  }

  void _onStepDetected(int stepCount) {
    // Update _currentLocation based on the step count and orientation
    double stepDistance = _strideLength; // The distance covered in one step
    double orientationInRadians = _orientationDetector.getOrientation() * (3.14159 / 180);
    double deltaX = stepDistance * cos(orientationInRadians);
    double deltaY = stepDistance * sin(orientationInRadians);
    _currentLocation = Location(
      name: 'Current Location',
      x: _currentLocation!.x + deltaX,
      y: _currentLocation!.y + deltaY,
    );
  }

  void _onOrientationChanged(double orientation) {
    // Update _currentLocation based on the orientation
    // This might not be necessary depending on your dead reckoning algorithm
  }

  Location? getCurrentLocation() {
    return _currentLocation;
  }

  Location? getDestination() {
    return _destination;
  }

  void setDestination(Location destination) {
    if (_origin != null) {
      _destination = Location(
        name: destination.name,
        x: destination.x - _origin!.x,
        y: destination.y - _origin!.y,
      );
    } else {
      _destination = destination;
    }
  }

  void setCurrentLocation(Location location) {
    if (_origin == null) {
      _origin = location;
    }
    _currentLocation = Location(
      name: location.name,
      x: location.x - _origin!.x,
      y: location.y - _origin!.y,
    );
  }
}
