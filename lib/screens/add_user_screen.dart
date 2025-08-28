// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:konata/controllers/add_user_controller.dart';
import 'package:konata/utils/methods.dart';
import 'package:konata/utils/variable.dart';
import 'package:panara_dialogs/panara_dialogs.dart';

class AddUserScreen extends StatefulWidget {
  const AddUserScreen({super.key});

  @override
  State<AddUserScreen> createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  final controller = Get.find<AddUserController>();

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
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      SizedBox(height: 20.0),
                      registAvatar,
                      SizedBox(height: 10.0),
                      buildTextBox(
                        controller.nickEditor.value,
                        (!controller.isNeedNick.value ? textBorder : errorBorder),
                        Icons.person,
                        '愛称',
                        horizontalPadding: (isIpad ? size.width / 4 : null),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                          left: isIpad ? size.width / 4 : 40.0,
                          top: 20.0,
                          right: isIpad ? size.width / 4 : 40.0,
                        ),
                        width: double.infinity,
                        height: 45.0,
                        child: DropdownButtonFormField(
                          decoration: InputDecoration(
                            hintText: '性別',
                            contentPadding: EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 10.0),
                            prefixIcon: Icon(Icons.person),
                            enabledBorder: (!controller.isNeedSex.value ? textBorder : errorBorder),
                            focusedBorder: focusBorder,
                          ),
                          items: [
                            DropdownMenuItem(value: '男', child: Text('男')),
                            DropdownMenuItem(value: '女', child: Text('女')),
                          ],
                          onChanged: (value) {
                            controller.sex.value = value!;
                          },
                          value: (controller.sex.value == '' ? null : controller.sex.value),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: isIpad ? size.width / 4 : 40.0,
                          top: 20.0,
                          right: isIpad ? size.width / 4 : 40.0,
                        ),
                        child: TextField(
                          controller: controller.birthdayEditor.value,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.calendar_today),
                            contentPadding: EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 10.0),
                            enabledBorder: (!controller.isNeedBirthday.value ? textBorder : errorBorder),
                            focusedBorder: focusBorder,
                            hintText: '生年月日',
                            // inputの端にカレンダーアイコンをつける
                            suffixIcon: IconButton(
                              icon: Icon(Icons.edit_calendar_rounded),
                              onPressed: () async {
                                // textFieldがの値からデフォルトの日付を取得する
                                DateTime initDate = DateTime.now();
                                try {
                                  if (controller.birthdayEditor.value.text != '') {
                                    initDate = DateFormat('yyyy-MM-dd').parse(controller.birthdayEditor.value.text);
                                  }
                                } catch (_) {}

                                // DatePickerを表示する
                                DateTime? picked = await showDatePicker(
                                  locale: const Locale("ja"),
                                  context: context,
                                  initialDate: initDate,
                                  firstDate: DateTime(2016),
                                  lastDate: DateTime.now().add(
                                    Duration(days: 360),
                                  ),
                                );

                                // DatePickerで取得した日付を文字列に変換
                                String? formatedDate;
                                try {
                                  if (picked != null) {
                                    formatedDate = DateFormat('yyyy-MM-dd').format(picked!);
                                  }
                                } catch (_) {}
                                if (formatedDate != null) {
                                  controller.birthdayEditor.value.text = formatedDate;
                                }
                              },
                            ),
                            // labelText: 'Password',
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 30.0),
                    child: Column(
                      children: [
                        buildBlueButton(
                          '登録',
                          () async {
                            if (!controller.check()) return;
                            await PanaraConfirmDialog.show(
                              context,
                              message: '登録しますか？',
                              confirmButtonText: 'OK',
                              cancelButtonText: 'キャンセル',
                              onTapConfirm: () async {
                                Navigator.pop(context);
                                await controller.regist();
                                Get.back(result: 'SAVE OK');
                              },
                              onTapCancel: () {
                                Navigator.pop(context);
                              },
                              panaraDialogType: PanaraDialogType.normal,
                              noImage: true,
                            );
                          },
                          horizontalMargin: (isIpad ? size.width / 4 : null),
                        ),
                        buildWhiteButton('戻る', () => Get.back(), horizontalMargin: (isIpad ? size.width / 4 : null)),
                      ],
                    ),
                  )
                ],
              ),
              copyRightWidget,
              Visibility(
                child: Center(
                  child: Container(
                    color: Colors.black.withOpacity(0.5),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ),
                visible: controller.isLoading.value,
              ),
            ],
          ),
        ),
        size.width);
  }
}
