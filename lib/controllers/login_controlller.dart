import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:konata/models/regist_api_models.dart';
import 'package:konata/utils/api_utils.dart';
import 'package:konata/utils/mem_utils.dart';
import 'package:konata/utils/variable.dart';

class LoginController extends GetxController {
  final isNeedEmail = false.obs;
  final isNeedPassword = false.obs;
  final isClicked = false.obs;

  final loginUser = RegistResponse().obs;
  final isLoading = false.obs;

  final emailController = TextEditingController().obs;
  final passwordController = TextEditingController().obs;

  ///ログイン<br>
  ///email:メール<br>
  ///password:パスワード
  login(String email, String password) async {
    isNeedEmail.value = (email == '');
    isNeedPassword.value = (password == '');
    if (email == '' || password == '') {
      loginUser.value = RegistResponse();
      return;
    }

    isLoading.value = true;
    //final passConvert = sha256Encrypt(password);
    var user = await loginParent(RegistUserInfo(mail: email, pass_txt: password), errorTest: false);

    if (user.errorCode == successCode) {
      await saveLoginUserToMemory(RegistUserInfo(aivo_id: user.aivo_id, parent_id: user.parent_id, pass_txt: password));
    }

    loginUser.value = user;

    isLoading.value = false;
  }

  clear() {
    emailController.value.text = "";
    passwordController.value.text = "";
    isNeedEmail.value = false;
    isNeedPassword.value = false;
    loginUser.value = RegistResponse();
  }
}
