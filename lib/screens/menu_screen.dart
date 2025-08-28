import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:konata/controllers/users_controller.dart';
import 'package:konata/utils/methods.dart';
import 'package:konata/utils/variable.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final controller = Get.find<UsersController>();
  int tabIndex = -1;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async => await controller.getUsers());
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return screenBody(
      ///body
      Obx(
        () => Stack(
          alignment: Alignment.topCenter,
          children: [
            clipArt,
            /*
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: MaterialButton(
                      elevation: 2.0,
                      shape: const CircleBorder(),
                      color: const Color.fromARGB(255, 51, 153, 51),
                      padding: const EdgeInsets.all(8),
                      onPressed: () => Get.toNamed('/user', arguments: controller.users.value!.toList()),
                      child: const Icon(Icons.handshake, size: 30, color: Colors.white),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, top: 10.0),
                    child: MaterialButton(
                      elevation: 2.0,
                      shape: const CircleBorder(),
                      color: const Color.fromARGB(255, 51, 153, 51),
                      padding: const EdgeInsets.all(8),
                      onPressed: () async => await launchUrl(Uri.parse(FIX_URL), mode: LaunchMode.externalApplication),
                      child: const Icon(Icons.web_sharp, size: 30, color: Colors.white),
                    ),
                  )
                ],
              ),
              */
            const Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: avatar,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 160.0),
              child: Column(
                children: controller.users.obs.value
                    .map(
                      (element) => Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: buildButton("${element.nickname!}のこと", isIpad, size.width, () {
                          selectUser = element; //対象人を保持
                          Get.toNamed('/top');
                        }),
                      ),
                    )
                    .toList(),
              ),
            ),
            copyRightWidget,
          ],
        ),
      ),
      size.width,
      bottomBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        iconSize: 30.0,
        currentIndex: tabIndex == -1 ? 0 : tabIndex,
        onTap: (value) async {
          setState(() {
            tabIndex = value;
          });
          if (value == 0) {
            Get.toNamed('/user');
          } else if (value == 1) {
            //await launchUrl(Uri.parse(FIX_URL), mode: LaunchMode.externalApplication);
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Users'),
          BottomNavigationBarItem(icon: Icon(Icons.language), label: 'Phone'),
        ],
        unselectedItemColor: Colors.grey.shade600,
        selectedItemColor: tabIndex == -1 ? Colors.grey.shade600 : Colors.blue,
      ),
    );
  }
}
