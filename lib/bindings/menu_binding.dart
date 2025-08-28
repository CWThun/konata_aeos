import 'package:get/get.dart';
import 'package:konata/controllers/users_controller.dart';

class MenuBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => UsersController());
  }
}
