import 'package:get/get.dart';
import 'package:konata/models/chats.dart';
import 'package:konata/utils/api_utils.dart';
import 'package:konata/utils/mem_utils.dart';
import 'package:konata/utils/methods.dart';
import 'package:konata/utils/variable.dart';

class HistoryController extends GetxController {
  var items = <HistoryModel>[].obs;
  var summary = ''.obs;
  var isLoading = false.obs;
  var isShowHistory = true.obs;

  ///会話履歴照会
  getHistory(ThemaType themaType) async {
    isShowHistory.value = true;
    if (items.isNotEmpty) {
      items.clear();
    }
    isLoading.value = true;
    try {
      var response = await getChatHistory(loginUser!.aivo_id!, themaType);
      if (response != null) {
        response.sort((a, b) => b.timestamp.compareTo(a.timestamp));
        items.addAll(response);
      }
    } catch (error) {
      isLoading.value = false;
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  ///問診履歴要約
  getHistorySummary() async {
    isShowHistory.value = false;
    summary.value = '';
    isLoading.value = true;
    try {
      var response = await getChatHistorySummary(loginUser!.aivo_id!);
      if (response != null) {
        summary.value = response;
      }
    } catch (error) {
      isLoading.value = false;
      showErrorSnackbar(error.toString());
      //rethrow;
    } finally {
      isLoading.value = false;
    }
  }
}
