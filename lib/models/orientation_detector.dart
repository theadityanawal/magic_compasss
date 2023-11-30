import 'package:sensors/sensors.dart';

class OrientationDetector {
  double _orientation = 0.0;
  bool _isDetecting = false;
  Function? _onOrientationChanged;

  void startListening({Function? onOrientationChanged}) {
    _isDetecting = true;
    _onOrientationChanged = onOrientationChanged;
    gyroscopeEvents.listen((GyroscopeEvent event) {
      if (_isDetecting) {
        _orientation += event.y;
        //print('Orientation changed. Current orientation: $_orientation');
        if (_onOrientationChanged != null) {
          _onOrientationChanged!(_orientation);
        }
      }
    });
  }

  void stopListening() {
    _isDetecting = false;
  }

  double getOrientation() {
    return _orientation;
  }

  void resetOrientation() {
    _orientation = 0.0;
  }
}