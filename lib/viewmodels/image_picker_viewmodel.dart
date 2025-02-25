import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerViewModel extends StateNotifier<XFile?> {
  ImagePickerViewModel() : super(null);

  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      state = image;
    }
  }
}

final imagePickerProvider = StateNotifierProvider<ImagePickerViewModel, XFile?>(
  (ref) => ImagePickerViewModel(),
);
