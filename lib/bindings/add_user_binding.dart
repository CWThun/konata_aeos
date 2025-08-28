import 'package:get/get.dart';
import 'package:konata/controllers/add_user_controller.dart';

class AddUserBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AddUserController());
  }
}
