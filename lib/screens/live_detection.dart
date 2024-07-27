// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, prefer_const_declarations, avoid_print, prefer_const_constructors

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:imagerecognizer_app/config/saved_data.dart';
import 'package:imagerecognizer_app/screens/Dashboard_screen.dart';
import 'package:imagerecognizer_app/screens/save_detected_text.dart';
import 'package:imagerecognizer_app/services/image_picker_service.dart';

class TextRecognition extends StatefulWidget {
  @override
  _TextRecognitionState createState() => _TextRecognitionState();
}

class _TextRecognitionState extends State<TextRecognition> {
  CameraController? _cameraController;
  late TextRecognizer _textRecognizer;
  bool _isDetecting = false;

  @override
  void initState() {
    data = '';
    super.initState();
    _initializeCamera();
    _textRecognizer = TextRecognizer();
  }

  dynamic data = '';

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final camera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back);

    _cameraController = CameraController(
      camera,
      ResolutionPreset.medium,
    );

    await _cameraController!.initialize();

    _cameraController!.startImageStream((CameraImage image) {
      if (_isDetecting) return;

      _isDetecting = true;

      _processCameraImage(image);
    });

    setState(() {});
  }

  Future<void> _processCameraImage(CameraImage image) async {
    final WriteBuffer allBytes = WriteBuffer();
    for (Plane plane in image.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();

    final Size imageSize =
        Size(image.width.toDouble(), image.height.toDouble());

    final InputImageRotation imageRotation = InputImageRotation.rotation0deg;

    final InputImageFormat inputImageFormat = InputImageFormat.nv21;

    final planeData = image.planes.map(
      (Plane plane) {
        return InputImagePlaneMetadata(
          bytesPerRow: plane.bytesPerRow,
          height: plane.height,
          width: plane.width,
        );
      },
    ).toList();

    final InputImage inputImage = InputImage.fromBytes(
      bytes: bytes,
      inputImageData: InputImageData(
        size: imageSize,
        imageRotation: imageRotation,
        inputImageFormat: inputImageFormat,
        planeData: planeData,
      ),
    );

    final RecognizedText recognizedText =
        await _textRecognizer.processImage(inputImage);
    if (!mounted) return;

    setState(() {
      data = recognizedText.text;
      print('Detected text: ${recognizedText.text}');
    });

    _isDetecting = false;
  }

  @override
  void dispose() {
    print('Dispose called');
    _cameraController?.dispose();
    _textRecognizer.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Live Text Recognition'),
      ),
      body: GestureDetector(
        onTap: () {
          saveddata = data.toString();
          print('${saveddata} saved data ');
          _cameraController?.stopImageStream();

          // setState(() {
          _isDetecting = false;
          Navigator.push(context,
              MaterialPageRoute(builder: (BuildContext context) {
            return SaveDetectedText(recognizedtext: data.toString());
          }));
        },
        child: Stack(
          children: [
            _cameraController == null
                ? Center(child: CircularProgressIndicator())
                : SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: CameraPreview(_cameraController!)),
            Padding(
              padding: const EdgeInsets.all(30),
              child: Text(
                '${data.toString()}',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}
