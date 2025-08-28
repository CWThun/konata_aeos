import 'package:get/get.dart';
import 'package:konata/controllers/top_controller.dart';

class TopBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TopController());
  }
}
