import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import '../services/calibration_service.dart';
import '../models/location.dart';
import '../services/navigation_service.dart';

class CalibrationView extends StatefulWidget {
  final CalibrationService calibrationService;
  final NavigationService navigationService;

  CalibrationView({required this.calibrationService, required this.navigationService});

  @override
  _CalibrationViewState createState() => _CalibrationViewState();
}

class _CalibrationViewState extends State<CalibrationView> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calibrate'),
      ),
      body: QRView(
        key: qrKey,
        onQRViewCreated: _onQRViewCreated,
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      if (scanData.code != null) {
        controller.pauseCamera();
        _calibrate(scanData.code!);
      }
    });
  }

  void _calibrate(String qrCodeData) {
    List<String> data = qrCodeData.split(',');
    String name = data[0];
    double x = double.parse(data[1]);
    double y = double.parse(data[2]);
    widget.calibrationService.calibrate(Location(name: name, x: x, y: y));
    widget.navigationService.setCurrentLocation(Location(name: name, x: x, y: y));
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Scan Successful'),
          content: Text('Setting location to $name'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
