import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:job_me/_shared/api/entities/image_file.dart';



Future<ImageFile?> pickImage(Function(ImageFile imageFile) onImageSelected) async {
  try {
    var image = await _pickAnImage();
    if (image != null) {
      onImageSelected(image);
    }
  } catch (e) {
    //ignore: usually, error is not thrown
  }
  return null;
}

Future<ImageFile?> _pickAnImage() async {
  final result = await FilePicker.platform.pickFiles(type: FileType.image, allowMultiple: false);
  if (_isPictureHasBeenSelected(result)) {
    return await _getImageFile(result);
  }
  return null;
}

bool _isPictureHasBeenSelected(FilePickerResult? result) {
  if (result != null && result.files.first.bytes != null && result.files.first.bytes!.isNotEmpty ||
      result != null && result.paths.isNotEmpty) {
    return true;
  }
  return false;
}

Future<ImageFile> _getImageFile(result) async {
  var path = result.paths[0];
  File file = File(path!);
  var fileBytes = await file.readAsBytes();
  var fileName = file.path;
  var imageFile = ImageFile(name: fileName, bytes: fileBytes);
  return imageFile;
}
