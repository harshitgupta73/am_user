import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerController extends GetxController {
  RxString imagePath = ''.obs;
  RxString licenceImage=''.obs;
  RxString rcImage = ''.obs;

  Future getImage() async {
    final ImagePicker _picker = ImagePicker();
    final image =await _picker.pickImage(source: ImageSource.gallery);

    if(image != null){
      imagePath.value= image.path;
    }
  }

  Future getLicenceImage() async {
    final ImagePicker _picker = ImagePicker();
    final image =await _picker.pickImage(source: ImageSource.gallery);

    if(image != null){
      licenceImage.value= image.path;
    }
  }

  Future getRCImage() async {
    final ImagePicker _picker = ImagePicker();
    final image =await _picker.pickImage(source: ImageSource.gallery);

    if(image != null){
      rcImage.value= image.path;
    }
  }
}