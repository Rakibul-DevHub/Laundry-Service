import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import 'app_logger.dart';

class ImagePickerUtils {
  static Future<File?> pickImageFile() async {
    try {
      final ImagePicker picker = ImagePicker();

      final XFile? pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
      );

      if (pickedFile != null) {
        final File file = File(pickedFile.path);
        return file;
        // final String ext = file.path.split('.').last.toLowerCase();
        // if (<String>['jpg', 'jpeg', 'png', 'heic'].contains(ext)) {
        //   return file;
        // } else {
        //   Toast.showError("❌ Unsupported image format: .$ext");
        //   AppLogger().e("❌ Unsupported image format: .$ext");
        //   return null;
        // }
      }
      AppLogger().e("Image not picked");

      return null;
    } catch (e) {
      AppLogger().e("Error picking image: $e");
      return null;
    }
  }

  static Future<File?> takeSelfie() async {
    try {
      final PermissionStatus status = await Permission.camera.status;
      if (!status.isGranted) {
        final PermissionStatus result = await Permission.camera.request();
        if (!result.isGranted) {
          AppLogger().d("Camera permission denied");
          return null;
        }
      }

      final ImagePicker picker = ImagePicker();

      final XFile? pickedFile = await picker.pickImage(
        source: ImageSource.camera,
      );

      if (pickedFile != null) {
        final File file = File(pickedFile.path);
        return file;
        // final String ext = file.path.split('.').last.toLowerCase();
        // if (<String>['jpg', 'jpeg', 'png', 'heic'].contains(ext)) {
        //   return file;
        // } else {
        //   Toast.showError("❌ Unsupported image format: .$ext");
        //   AppLogger().e("❌ Unsupported image format: .$ext");
        //   return null;
        // }
      }
      AppLogger().e("Image not picked");

      return null;
    } catch (e) {
      AppLogger().e("Error picking image: $e");
      return null;
    }
  }

  static Future<List<File>?> pickMultipleImageFiles() async {
    try {
      final ImagePicker picker = ImagePicker();

      final List<File> pickedFiles = <File>[];

      final List<XFile> pickedXFiles = await picker.pickMultiImage();

      for (final XFile val in pickedXFiles) {
        pickedFiles.add(File(val.path));
      }

      return pickedFiles;
    } catch (e) {
      AppLogger().e("Error picking images: $e");
      return null;
    }
  }
}
