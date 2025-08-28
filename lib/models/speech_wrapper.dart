// ignore_for_file: unnecessary_brace_in_string_interps, avoid_print

import 'package:konata/utils/methods.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechWrapper {
  final SpeechToText speech = SpeechToText();
  bool speechEnabled = false;

  ///STT初期化
  void initSpeech(Function? errorFunc, {Function? callFunc}) async {
    speechEnabled = await speech.initialize(
      onError: (errorNotification) {
        print('ERROR:${errorNotification}');
        if (errorFunc != null) {
          print('RECALL AFTER ERROR');
          errorFunc();
        }
      },
      onStatus: (status) {
        print('STATUS:$status');
      },
    );

    /*
    speech.errorListener = (errorNotification) {
      print('ERROR:${errorNotification}');
      if (errorFunc != null) {
        print('RECALL AFTER ERROR');
        errorFunc();
      }
    };
    */
    if (callFunc != null) {
      callFunc();
    }
  }

  ///STTスタート
  startListening(Function? afterFunc, Function? stopWaitTimer) {
    if (speechEnabled) {
      print('START--------------------------------------');
      speech.listen(
        localeId: 'ja-JP',
        listenFor: const Duration(seconds: 7),
        pauseFor: const Duration(seconds: 5),
        listenOptions: SpeechListenOptions(cancelOnError: true, partialResults: true),
        onResult: (result) {
          if (result.finalResult) {
            //showErrorSnackbar('speech_recognized:${result.recognizedWords}');
            print('LISTEN:${result.recognizedWords},Confidence:${result.confidence}');
            afterFunc!(result.recognizedWords, result.confidence);
          } else {
            print('PARTIAL:${result.recognizedWords},Confidence:${result.confidence}');
            if (stopWaitTimer != null) {
              print('STOP WAIT TIMER');
              // 停止タイマーを停止する
              stopWaitTimer();
            }
          }
        },
      );
    } else {
      showErrorSnackbar('音声認識が有効ではありません。');
    }
  }

  ///STTストップ
  stopListening() async {
    if (speechEnabled && speech.isListening) {
      await speech.stop();
    }
  }

  ///STT解放
  void dispose() {
    speech.stop();
  }
}
