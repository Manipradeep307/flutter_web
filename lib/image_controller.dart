import 'package:get/get.dart';

class ImageController extends GetxController {
  var imageUrl = RxnString();  // Observable image URL (null by default)
  var isMenuOpen = false.obs;  // Observable menu state

  void loadImage(String url) {
    imageUrl.value = url;
  }

  void toggleMenu() {
    isMenuOpen.value = !isMenuOpen.value;
  }

  void closeMenu() {
    isMenuOpen.value = false;
  }
}
