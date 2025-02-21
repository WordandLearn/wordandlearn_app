import 'package:cross_file/cross_file.dart';
import 'package:cunning_document_scanner/cunning_document_scanner.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';

class FileUtils {
  static XFile getFileFromPath(String path) {
    return XFile(path);
  }

  static Future<List<XFile>?> pickFilesWeb({bool allowMultiple = true}) async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(allowMultiple: allowMultiple);

    if (result != null && result.files.isNotEmpty) {
      // Generate an XFile object using the bytes
      List<XFile> files = result.files
          .map((file) => XFile.fromData(file.bytes!, name: file.name))
          .toList();
      return files;
    } else {
      return null;
    }
  }

  static Future<List<XFile>?> pickDocumentFiles(
      {bool allowMultiple = true}) async {
    if (kIsWeb) {
      return pickFilesWeb(allowMultiple: allowMultiple);
    } else {
      List<String?>? pictures = await CunningDocumentScanner.getPictures(
          noOfPages: allowMultiple ? 2 : 1, isGalleryImportAllowed: true);
      if (pictures != null && pictures.isNotEmpty) {
        return pictures.map(
          (e) {
            return XFile(e!);
          },
        ).toList();
      }
    }
    return null;
  }
}
