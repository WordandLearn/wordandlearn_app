import 'dart:developer';
import 'dart:io';

import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class OCRUtils {
  static Future<String?> getTextFromImage(File file) async {
    log("OCRING THE THING");
    final TextRecognizer textRecognizer =
        TextRecognizer(script: TextRecognitionScript.latin);
    log("PROCESSINGG");
    final InputImage inputImage = InputImage.fromFile(file);
    final RecognizedText recognizedText =
        await textRecognizer.processImage(inputImage);
    log("PROCESSINGG AGAIN");

    String text = recognizedText.text;
    log(text);

    textRecognizer.close();
    return text;
  }
}
