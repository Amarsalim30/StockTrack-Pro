import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class BarcodeScannerWidget extends StatefulWidget {
  final Function(String) onScanned;

  const BarcodeScannerWidget({Key? key, required this.onScanned})
    : super(key: key);

  @override
  State<BarcodeScannerWidget> createState() => _BarcodeScannerWidgetState();
}

class _BarcodeScannerWidgetState extends State<BarcodeScannerWidget> {
  final MobileScannerController _controller = MobileScannerController();
  bool _hasScanned = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleScannedCode(String code) {
    if (!_hasScanned) {
      setState(() {
        _hasScanned = true;
      });
      _controller.stop();
      widget.onScanned(code);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        MobileScanner(
          controller: _controller,
          fit: BoxFit.cover,
          onDetect: (BarcodeCapture capture) {
            if (capture.barcodes.isNotEmpty) {
              final String? code = capture.barcodes.first.displayValue;
              if (code != null) {
                _handleScannedCode(code);
              }
            }
          },
        ),
        if (_hasScanned) const Center(child: CircularProgressIndicator()),
      ],
    );
  }
}
