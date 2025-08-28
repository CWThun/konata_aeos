import 'package:get/get.dart';
import 'package:konata/controllers/login_controlller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LoginController());
  }
}
