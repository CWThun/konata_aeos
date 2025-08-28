import 'package:get/get.dart';
import 'package:konata/models/regist_api_models.dart';
import 'package:konata/utils/api_utils.dart';
import 'package:konata/utils/mem_utils.dart';

class UsersController extends GetxController {
  var users = <RegistUserInfo>[].obs;

  ///ユーザー照会
  getUsers() async {
    if (users.isNotEmpty) {
      users.clear();
    }
    var response = await reference(RegistUserInfo(aivo_id: loginUser!.aivo_id, parent_id: loginUser!.parent_id));
    if (response.user_list != null) {
      users.addAll(response.user_list!);
    }
  }
}
