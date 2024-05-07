import 'package:image_picker/image_picker.dart';

class ImagePickerHelper {
  static ImagePickerHelper? _imagePickerHelper;
  static late ImagePicker _imagePicker;

  ImagePickerHelper._internal() {
    _imagePickerHelper = this;
  }

  factory ImagePickerHelper() =>
      _imagePickerHelper ?? ImagePickerHelper._internal();

  ImagePicker get imagePicker {
    _imagePicker = ImagePicker();
    return _imagePicker;
  }

  Future<String?> pickImagePath() async {
    final result = await imagePicker.pickImage(source: ImageSource.gallery);
    return result?.path;
  }
}
