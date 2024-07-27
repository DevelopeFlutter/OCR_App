// ignore_for_file: must_be_immutable, prefer_const_constructors, unnecessary_string_interpolations

import 'package:flutter/material.dart';
import 'package:imagerecognizer_app/config/saved_data.dart';
import 'package:imagerecognizer_app/services/image_picker_service.dart';

import '../utils/utils.dart';
import 'Dashboard_screen.dart';

class SaveDetectedText extends StatefulWidget {
  String? recognizedtext;

  SaveDetectedText({super.key, this.recognizedtext});

  @override
  State<SaveDetectedText> createState() => _SaveDetectedTextState();
}

class _SaveDetectedTextState extends State<SaveDetectedText> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Dashboard()),
        );
        // Navigator.pushReplacementNamed(context,);
        return false;
      },
      child: Scaffold(
        // backgroundColor: Colors.blue.shade200,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.blue,
          centerTitle: true,
          title: Text(
            'Detected Text',
            style: TextStyle(
                // fontSize: 20,
                color: Colors.white),
          ),
          actions: [
            IconButton(
              icon: Icon(
                Icons.copy,
                color: Colors.white,
              ),
              onPressed: () {
              copyClipBoard(saveddata);
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  '${saveddata}',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
