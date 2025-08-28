import 'package:get/get.dart';

class TopController extends GetxController {
  final statusIndex = 1.obs;
  final title = 'どうですか？'.obs;

  listen() {
    statusIndex.value = 1;
    title.value = 'どうですか？';
  }

  noSymtom(String msg) {
    statusIndex.value = 2;
    title.value = msg;
  }
}
