// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last, avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:konata/controllers/login_controlller.dart';
import 'package:konata/utils/methods.dart';
import 'package:konata/utils/variable.dart';
import 'package:panara_dialogs/panara_dialogs.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final controller = Get.find<LoginController>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return screenBody(
        Obx(
          () => Stack(
            children: [
              clipArt,
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      foregroundImage: AssetImage('assets/images/login3.png'),
                      radius: 46.0,
                    ),
                    SizedBox(height: 5.0),
                    Text('Login', style: bigTextStyle),
                    SizedBox(height: 20.0),
                    buildTextBox(
                      controller.emailController.value,
                      (!controller.isNeedEmail.value ? textBorder : errorBorder),
                      Icons.mail,
                      'メール',
                      horizontalPadding: (isIpad ? size.width / 4 : null),
                    ),
                    SizedBox(height: 20),
                    buildTextBox(
                      controller.passwordController.value,
                      (!controller.isNeedPassword.value ? textBorder : errorBorder),
                      Icons.key,
                      'パスワード',
                      isPass: true,
                      horizontalPadding: (isIpad ? size.width / 4 : null),
                    ),
                    Visibility(
                      visible: controller.loginUser.value.errorCode != successCode && controller.loginUser.value.errorMessage != null && controller.loginUser.value.errorMessage! != '',
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Text(controller.loginUser.value.errorMessage != null ? controller.loginUser.value.errorMessage! : '', style: TextStyle(color: Colors.red)),
                      ),
                    ),
                    SizedBox(height: 60),
                    buildBlueButton(
                      'ログイン',
                      () async {
                        await controller.login(controller.emailController.value.text, controller.passwordController.value.text);
                        if (controller.loginUser.value.errorCode == successCode) {
                          print(controller.loginUser.value);
                          Get.offNamed('/chat');
                        } else if (controller.loginUser.value.errorCode == errorCode) {
                          FocusScope.of(context).unfocus();
                          return;
                          /*
                          await PanaraInfoDialog.show(
                            context,
                            message: controller.loginUser.value.errorMessage!,
                            buttonText: 'OK',
                            onTapDismiss: () {
                              Navigator.pop(context);
                            },
                            panaraDialogType: PanaraDialogType.error,
                          );
                          */
                        }
                      },
                      horizontalMargin: (isIpad ? size.width / 4 : null),
                    ),
                    buildWhiteButton('登録', () {
                      controller.clear();
                      FocusScope.of(context).unfocus();
                      Get.toNamed('/regist');
                    }, horizontalMargin: (isIpad ? size.width / 4 : null)),
                  ],
                ),
              ),
              copyRightWidget,
              loadingWidget(controller.isLoading.value),
            ],
          ),
        ),
        size.width);
  }
}
