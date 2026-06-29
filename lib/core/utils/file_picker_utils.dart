import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'app_logger.dart';

class FilePickerUtils {
  static Future<File?> pickFile() async {
    try {
      final FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.any,
      );

      if (result != null && result.files.single.path != null) {
        return File(result.files.single.path!);
      } else {
        return null;
      }
    } catch (e) {
      AppLogger().e('Error picking file: $e');
      return null;
    }
  }
}
