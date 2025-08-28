import 'package:get/get.dart';
import 'package:konata/controllers/qna_controller.dart';

class QnABinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => QnAController());
  }
}
