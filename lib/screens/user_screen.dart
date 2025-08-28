import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:konata/controllers/users_controller.dart';
import 'package:konata/models/regist_api_models.dart';
import 'package:konata/utils/methods.dart';
import 'package:konata/utils/variable.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final controller = Get.find<UsersController>();
  final grayColor = const Color.fromARGB(255, 204, 204, 204);
  final blueColor = const Color.fromARGB(255, 204, 255, 204);

  List<RegistUserInfo> users = <RegistUserInfo>[];

  Future<void> reloadUser() async {
    await controller.getUsers();
    setState(() {
      users = controller.users.value!.toList();
    });
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      await reloadUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    //final users = Get.arguments != null ? Get.arguments as List<RegistUserInfo> : <RegistUserInfo>[];

    return screenBody(
      Stack(
        alignment: Alignment.topCenter,
        children: [
          clipArt,
          Column(
            children: buildUsers(users, size.width),
          ),
          copyRightWidget
        ],
      ),
      size.width,
    );
  }

  List<Widget> buildUsers(List<RegistUserInfo> users, double screenWidth) {
    List<Widget> lst = [];
    lst.add(const SizedBox(height: 20));
    lst.add(registAvatar);
    lst.add(const SizedBox(height: 10));
    lst.add(Text(
      users.isNotEmpty ? 'この先生と繋がりますか？' : '繋がりがいません。',
      style: textStyle,
    ));

    for (var user in users) {
      lst.add(const SizedBox(height: 20));
      lst.add(buildButton(user.nickname!, isIpad, screenWidth, () => {}, bgColor: (user.aeos_parameter!.isNotEmpty ? blueColor : grayColor)));
    }

    lst.add(const SizedBox(height: 20));
    lst.add(buildButton(
      '追加する方の御名前',
      isIpad,
      screenWidth,
      () async {
        final result = await Get.toNamed('/adduser');
        //add user
        if (result != null) {
          print('AAAAAAAAAAAAAAAAAA');
          await reloadUser();
        }
      },
      color: const Color.fromARGB(255, 216, 216, 216),
    ));
    lst.add(const SizedBox(height: 20));
    lst.add(buildButton('いいえ', isIpad, screenWidth, () => Get.back()));

    return lst;
  }
}
