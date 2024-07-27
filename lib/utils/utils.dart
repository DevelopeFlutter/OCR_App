import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

void copyClipBoard(text) {
  Clipboard.setData(ClipboardData(text: text)).then((_) {
    text.isNotEmpty && text != null
        ? Fluttertoast.showToast(
            msg: 'Text copied to clipboard',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
          )
        : null;
  }).catchError((error) {
    Fluttertoast.showToast(
      msg: 'Error copying text to clipboard',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  });
}
