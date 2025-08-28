import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:konata/models/regist_api_models.dart';
import 'package:konata/utils/api_utils.dart';
import 'package:konata/utils/mem_utils.dart';

class AddUserController extends GetxController {
  final nickEditor = TextEditingController().obs;
  final sex = ''.obs;
  final birthdayEditor = TextEditingController().obs;

  final isNeedNick = false.obs;
  final isNeedSex = false.obs;
  final isNeedBirthday = false.obs;
  final isClicked = false.obs;
  final isLoading = false.obs;

  ///登録
  check() {
    isClicked.value = true;
    if (nickEditor.value.text == '') isNeedNick.value = true;
    if (sex.value == '') isNeedSex.value = true;
    if (birthdayEditor.value.text == '') isNeedBirthday.value = true;
    if (nickEditor.value.text == '' || sex.value == '' || birthdayEditor.value.text == '') {
      return false;
    }
    isNeedNick.value = false;
    isNeedSex.value = false;
    isNeedBirthday.value = false;
    return true;
  }

  regist() async {
    isLoading.value = true;
    final ret = await registChild(RegistUserInfo(
        aivo_id: loginUser!.aivo_id,
        parent_id: loginUser!.parent_id,
        nickname: nickEditor.value.text,
        sex: sex.value,
        birthmonth: birthdayEditor.value.text));
    await Future.delayed(const Duration(seconds: 2));
    isLoading.value = false;
  }
}
