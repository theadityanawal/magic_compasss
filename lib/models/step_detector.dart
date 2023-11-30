import 'package:sensors/sensors.dart';
import 'package:pedometer/pedometer.dart';

class StepDetector {
  static const double _threshold = 15.0;
  int _stepCount = 0;
  bool _isDetecting = false;
  Function? _onStepDetected;
  Stream<StepCount>? _stepCountStream;

  void startListening({Function? onStepDetected}) {
    _isDetecting = true;
    _onStepDetected = onStepDetected;

    // Try to use the step counter sensor if it's available
    _stepCountStream = Pedometer.stepCountStream;

    if (_stepCountStream != null) {
      _stepCountStream!.listen((StepCount event) {
        _stepCount = event.steps;
        print('Step detected by step counter sensor. Total steps: $_stepCount');
        if (_onStepDetected != null) {
          _onStepDetected!(_stepCount);
        }
      });
    } else {
      // Fallback to using the accelerometer if the step counter sensor is not available
      accelerometerEvents.listen((AccelerometerEvent event) {
        if (_isDetecting && _isStep(event)) {
          _stepCount++;
          print('Step detected by accelerometer. Total steps: $_stepCount');
          if (_onStepDetected != null) {
            _onStepDetected!(_stepCount);
          }
        }
      });
    }
  }

  void stopListening() {
    _isDetecting = false;
  }

  int getStepCount() {
    return _stepCount;
  }

  void resetStepCount() {
    _stepCount = 0;
  }

  bool _isStep(AccelerometerEvent event) {
    double magnitude = _calculateMagnitude(event);
    return magnitude > _threshold;
  }

  double _calculateMagnitude(AccelerometerEvent event) {
    return (event.x * event.x) + (event.y * event.y) + (event.z * event.z);
  }
}
