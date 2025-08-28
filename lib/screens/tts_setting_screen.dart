import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:konata/models/tts_setup.dart';
import 'package:konata/models/tts_wrapper.dart';
import 'package:konata/utils/mem_utils.dart';
import 'package:konata/utils/variable.dart';

class TtsSettingScreen extends StatefulWidget {
  const TtsSettingScreen({Key? key}) : super(key: key);

  @override
  State<TtsSettingScreen> createState() => _TtsSettingScreenState();
}

class _TtsSettingScreenState extends State<TtsSettingScreen> {
  String _voiceOption = 'no_voice';
  String _gender = 'male';
  TTSSetup? ttsSetup = null;

  TextEditingController _waitTimeController = TextEditingController();
  TextEditingController _aiWaitTimeController = TextEditingController();
  final TTSWrapper tts = TTSWrapper();

  void _onSave() {
    ttsSetup!.voiceOption = _voiceOption;
    ttsSetup!.voiceGender = _gender;
    ttsSetup!.waitTime = double.tryParse(_waitTimeController.text) ?? 3.0;
    ttsSetup!.aiWaitTime = double.tryParse(_aiWaitTimeController.text) ?? 10.0;
    saveTTSSetupToMemory(ttsSetup!);
    Get.back(result: true);
  }

  Future<void> _onTestVoice() async {
    await tts.setVoiceByGender(_gender == 'male' ? VoiceGender.male : VoiceGender.female);
    await tts.speakAndWait("こんにちは。${_gender == 'male' ? "男性" : "女性"}の声です");
  }

  Future<void> loadData() async {
    final setup = await getTTSSetupFromMemory();
    setState(() {
      ttsSetup = setup;
      ttsSetup ??= TTSSetup();
      _voiceOption = ttsSetup?.voiceOption ?? 'no_voice';
      _gender = ttsSetup?.voiceGender ?? 'male';
    });
    String val = ttsSetup?.waitTime?.toString() ?? '3';
    if (val.isEmpty || double.tryParse(val) == null) {
      val = '3';
    }
    _waitTimeController.text = val;

    String val2 = ttsSetup?.aiWaitTime?.toString() ?? '10';
    if (val2.isEmpty || double.tryParse(val2) == null) {
      val2 = '10';
    }
    _aiWaitTimeController.text = val2;
  }

  @override
  void initState() {
    super.initState();
    tts.initializeTts();
    loadData();
  }

  @override
  void dispose() {
    tts.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: bgColor,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          backgroundColor: bgColor,
          leading: GestureDetector(
            onTap: () => Get.back(result: false),
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Image.asset('assets/images/home.png', height: 50),
            ),
          ),
          title: const Text('音声設定'),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '発音選択',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              ListTile(
                title: const Text('発音しない'),
                leading: Radio<String>(
                  value: 'no_voice',
                  groupValue: _voiceOption,
                  onChanged: (value) {
                    setState(() {
                      _voiceOption = value!;
                    });
                  },
                ),
                onTap: () => setState(() {
                  _voiceOption = 'no_voice';
                }),
              ),
              ListTile(
                title: const Text('発音する'),
                leading: Radio<String>(
                  value: 'voice',
                  groupValue: _voiceOption,
                  onChanged: (value) {
                    setState(() {
                      _voiceOption = value!;
                    });
                  },
                ),
                onTap: () => setState(() {
                  _voiceOption = 'voice';
                }),
              ),
              if (_voiceOption == 'voice') ...[
                Padding(
                  padding: const EdgeInsets.only(left: 32.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        title: const Text('女性の声'),
                        leading: Radio<String>(
                          value: 'female',
                          groupValue: _gender,
                          onChanged: (value) {
                            setState(() {
                              _gender = value!;
                            });
                          },
                        ),
                        onTap: () => setState(() {
                          _gender = 'female';
                        }),
                      ),
                      ListTile(
                        title: const Text('男性の声'),
                        leading: Radio<String>(
                          value: 'male',
                          groupValue: _gender,
                          onChanged: (value) {
                            setState(() {
                              _gender = value!;
                            });
                          },
                        ),
                        onTap: () => setState(() {
                          _gender = 'male';
                        }),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(
                    width: 100,
                    child: Text(
                      '待ち間隔',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  //add textbox for wait time input
                  // change width for textbox to fit the screen
                  const SizedBox(width: 5),
                  SizedBox(
                    width: 150,
                    height: 40,
                    child: TextField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: '秒数',
                      ),
                      keyboardType: TextInputType.number,
                      controller: _waitTimeController,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(
                    width: 100,
                    child: Text(
                      'AI待ち間隔',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 5),
                  SizedBox(
                    width: 150,
                    height: 40,
                    child: TextField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: '秒数',
                      ),
                      keyboardType: TextInputType.number,
                      controller: _aiWaitTimeController,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 110,
                    child: ElevatedButton(
                      onPressed: _onSave,
                      child: const Text('保存'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  SizedBox(
                    width: 110,
                    child: ElevatedButton(
                      onPressed: _voiceOption == 'voice' ? () async => await _onTestVoice() : null,
                      child: const Text('音声確認'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
            ],
          ),
        ),
      ),
    );
  }
}
