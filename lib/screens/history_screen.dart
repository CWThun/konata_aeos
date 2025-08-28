// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:konata/controllers/history_controller.dart';
import 'package:konata/utils/methods.dart';
import 'package:konata/utils/variable.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final controller = Get.find<HistoryController>();

  ///get arguments
  final ThemaType themaType = Get.arguments['thema'];

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async => await controller.getHistory(themaType));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: bgColor,
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Image.asset('assets/images/home.png', height: 50),
          ),
        ),
        centerTitle: true,
        title: Visibility(
          visible: themaType != ThemaType.Disaster,
          child: Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: InkWell(
              onTap: () async {
                await controller.getHistorySummary();
              },
              child: Image.asset('assets/images/cong.png', height: 45),
            ),
          ),
        ),
        actions: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                Get.offNamed('/barcode');
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Icon(
                  Icons.qr_code_2,
                  color: Colors.black, //Color.fromARGB(255, 114, 191, 197),
                  size: 40,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(15),
          //onLongPress: () => print('Long press to copy text'),

          child: Obx(() {
            if (controller.isLoading.value) {
              return Center(child: CircularProgressIndicator());
            }

            if (controller.isShowHistory.value) {
              return SelectableText.rich(
                TextSpan(
                  children: controller.items.expand((item) {
                    return [
                      TextSpan(
                        text: '🕒 ${item.timestamp.substring(0, 10).replaceAll('-', '.')}\n',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: '${item.content}\n\n'),
                    ];
                  }).toList(),
                ),
                contextMenuBuilder: (context, selectableTextState) {
                  final value = selectableTextState.textEditingValue;
                  final selectedText = value.selection.textInside(value.text);

                  return AdaptiveTextSelectionToolbar.buttonItems(
                    anchors: selectableTextState.contextMenuAnchors,
                    buttonItems: [
                      ContextMenuButtonItem(
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: selectedText));
                          selectableTextState.hideToolbar();
                        },
                        label: 'コピー',
                      ),
                    ],
                  );
                },
              );
            }

            return SelectableText(
              controller.summary.value,
              contextMenuBuilder: (context, selectableTextState) {
                final value = selectableTextState.textEditingValue;
                final selectedText = value.selection.textInside(value.text);

                return AdaptiveTextSelectionToolbar.buttonItems(
                  anchors: selectableTextState.contextMenuAnchors,
                  buttonItems: [
                    ContextMenuButtonItem(
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: selectedText));
                        selectableTextState.hideToolbar();
                      },
                      label: 'コピー',
                    ),
                  ],
                );
              },
            );
          }),
        ),
      ),
    );
  }
}
