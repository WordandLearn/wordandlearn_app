import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class OCRUtils {
  static File applyColorFilter(File image) {
    final img.Image originalImage = img.decodeImage(image.readAsBytesSync())!;
    // Apply a color filter to the image, only keep pixels with an alpha value greater
    final img.Image grayscaleImage = img.grayscale(originalImage);

    // Apply binarization (thresholding)
    // final img.Image binaryImage = img.threshold(grayscaleImage, 128);

    // Apply noise reduction
    // final img.Image denoisedImage = img.gaussianBlur(binaryImage, radius:1);

    final Uint8List processedBytes = img.encodeJpg(grayscaleImage);

    return File(image.path)..writeAsBytesSync(processedBytes);
  }

  static Future<String?> getTextFromImage(File file) async {
    file = applyColorFilter(file);

    final TextRecognizer textRecognizer =
        TextRecognizer(script: TextRecognitionScript.latin);
    final InputImage inputImage = InputImage.fromFile(file);
    final RecognizedText recognizedText =
        await textRecognizer.processImage(inputImage);
    String result = "";
    for (TextBlock block in recognizedText.blocks) {
      //each block of text/section of text
      for (TextLine line in block.lines) {
        //each line within a text block
        for (TextElement element in line.elements) {
          //each word within a line
          result += "${element.text} ";
        }
      }
    }
    result += "\n\n";
    log(result);
    textRecognizer.close();
    return result;
  }
}
