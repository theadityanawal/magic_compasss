import '../models/location.dart';

class CalibrationService {
  Location? _currentCalibrationPoint;

  void calibrate(Location calibrationPoint) {
    _currentCalibrationPoint = calibrationPoint;
    //print('Calibrated at ${calibrationPoint.name}');
  }

  Location? getCurrentCalibrationPoint() {
    return _currentCalibrationPoint;
  }
  
  void updateCurrentLocation(String qrCodeData) {
    List<String> data = qrCodeData.split(',');
    String name = data[0];
    double x = double.parse(data[1]);
    double y = double.parse(data[2]);
    _currentCalibrationPoint = Location(name: name, x: x, y: y);
  }
}

