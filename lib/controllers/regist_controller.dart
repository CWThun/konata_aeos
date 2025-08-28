import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:konata/models/regist_api_models.dart';
import 'package:konata/utils/api_utils.dart';
import 'package:konata/utils/mem_utils.dart';
import 'package:konata/utils/variable.dart';

class RegistController extends GetxController {
  final emailEditor = TextEditingController().obs;
  final passwordEditor = TextEditingController().obs;
  final confirmPasswordEditor = TextEditingController().obs;
  //final sex = ''.obs;
  //final birthdayEditor = TextEditingController().obs;

  final isNeedEmail = false.obs;
  final isNeedPassword = false.obs;
  final isNeedConfirmPassword = false.obs;
  //final isNeedSex = false.obs;
  //final isNeedBirthday = false.obs;
  final isClicked = false.obs;
  final isLoading = false.obs;

  ///登録
  check() {
    isClicked.value = true;
    isNeedEmail.value = emailEditor.value.text == '';
    isNeedPassword.value = passwordEditor.value.text == '';
    isNeedConfirmPassword.value = (passwordEditor.value.text != confirmPasswordEditor.value.text);
    //isNeedSex.value = sex.value == '';
    //isNeedBirthday.value = birthdayEditor.value.text == '';

    ///入力エラー
    if (emailEditor.value.text == '' ||
            passwordEditor.value.text == '' ||
            confirmPasswordEditor.value.text == '' ||
            passwordEditor.value.text != confirmPasswordEditor.value.text
        //sex.value == '' ||
        //birthdayEditor.value.text == ''
        ) {
      return false;
    }

    isNeedEmail.value = false;
    isNeedPassword.value = false;
    isNeedConfirmPassword.value = false;
    //isNeedSex.value = false;
    //isNeedBirthday.value = false;
    return true;
  }

  Future<String> regist() async {
    isLoading.value = true;
    //final passwordConvert = sha256Encrypt(passwordEditor.value.text);
    final ret = await registParent(RegistUserInfo(
      mail: emailEditor.value.text,
      pass_txt: passwordEditor.value.text,
      /*
        pass_hash: passwordConvert,
        sex: sex.value,
        birthmonth: birthdayEditor.value.text
        */
    ));
    //await Future.delayed(const Duration(seconds: 2));

    isLoading.value = false;

    //成功
    if (ret.errorCode == successCode) {
      await saveLoginUserToMemory(
          RegistUserInfo(aivo_id: ret.aivo_id, parent_id: ret.parent_id, pass_txt: passwordEditor.value.text));
      print(ret.toJson());
      return "";
    }
    //失敗
    else {
      return ret.errorMessage!;
    }
  }
}
