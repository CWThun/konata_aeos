// ignore_for_file: prefer_const_constructors, avoid_print

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:konata/utils/api_utils.dart';
import 'package:konata/utils/mem_utils.dart';
import 'package:konata/utils/methods.dart';
import 'package:konata/utils/variable.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:panara_dialogs/panara_dialogs.dart';

class BarcodeScanner extends StatefulWidget {
  const BarcodeScanner({super.key});

  @override
  State<BarcodeScanner> createState() => _BarcodeScannerState();
}

class _BarcodeScannerState extends State<BarcodeScanner> {
  MobileScannerController controller = MobileScannerController(detectionSpeed: DetectionSpeed.noDuplicates);

  String strBarcode = '';
  bool isScanning = false;
  bool isClicking = false;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      isScanning = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: bgColor,
      appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          backgroundColor: bgColor,
          centerTitle: true,
          leading: GestureDetector(
            onTap: () => Get.back(),
            child: Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Image.asset('assets/images/home.png', height: 50),
            ),
          )),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              width: size.width,
              margin: const EdgeInsets.all(15.0),
              color: bgColor,
              padding: const EdgeInsets.symmetric(vertical: 18.0),
              child: Center(
                child: Column(
                  children: [
                    if (isScanning)
                      SizedBox(
                        height: size.width * 4 / 3,
                        child: MobileScanner(
                          controller: controller,
                          fit: BoxFit.contain,
                          onDetect: (barcodes) async {
                            if (barcodes.barcodes.isNotEmpty) {
                              final barcode = barcodes.barcodes.firstWhere(
                                (b) => b.rawValue != null || b.displayValue != null,
                                orElse: () => Barcode(
                                  rawValue: null,
                                  displayValue: null,
                                  format: BarcodeFormat.unknown,
                                ),
                              );

                              final code = barcode.rawValue ?? barcode.displayValue;
                              if (code != null) {
                                print('BARCODE:$code');
                                controller.stop();
                                await Future.delayed(Duration(seconds: 1));
                                setState(() {
                                  strBarcode = code;
                                  isScanning = false;
                                });
                              }
                            }
                          },
                        ),
                      )
                    else
                      Container(
                        height: size.width * 4 / 3,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                        ),
                        child: Center(
                          child: buildWhiteButton('再読み込む', () async {
                            if (isScanning) {
                              return;
                            }
                            setState(() {
                              isScanning = true;
                            });
                            await Future.delayed(Duration(seconds: 1));
                            controller.start();
                          }, horizontalMargin: 5, width: 130.0),
                        ),
                      ),
                    const SizedBox(height: 10.0),
                    Text('バーコード：$strBarcode', style: const TextStyle(fontSize: 16.0)),
                    const SizedBox(height: 10.0),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (strBarcode.isNotEmpty)
                          buildBlueButton('連携', () async {
                            if (isClicking) {
                              return;
                            }
                            setState(() {
                              isClicking = true;
                            });
                            try {
                              final message = await registBarcode(loginUser!.aivo_id!, strBarcode);
                              if (message == '連携許可に成功しました') {
                                await showErrorDialog(context, message, () => Get.back(), panaraDialogType: PanaraDialogType.normal);
                                Get.back();
                              } else {
                                showErrorSnackbar(message);
                              }
                            } catch (e) {
                              showErrorSnackbar(e.toString());
                            } finally {
                              setState(() {
                                isClicking = false;
                              });
                            }
                          }, horizontalMargin: 5, width: 150.0)
                        else
                          SizedBox()
                      ],
                    )
                  ],
                ),
              ),
            ),
            Visibility(child: Center(child: CircularProgressIndicator()), visible: isClicking),
          ],
        ),
      )),
    );
  }
}
