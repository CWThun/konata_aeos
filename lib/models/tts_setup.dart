class TTSSetup {
  String? voiceOption;
  String? voiceGender;
  double? waitTime;
  double? aiWaitTime;
  TTSSetup({this.voiceOption, this.voiceGender, this.waitTime, this.aiWaitTime});
  factory TTSSetup.fromJson(Map<String, dynamic> json) {
    var ttsSetup = TTSSetup();
    if (json["voiceOption"] != null) {
      ttsSetup.voiceOption = json['voiceOption'] as String;
    }
    if (json["voiceGender"] != null) {
      ttsSetup.voiceGender = json['voiceGender'] as String;
    }
    if (json["waitTime"] != null) {
      ttsSetup.waitTime = json['waitTime'] as double;
    }
    if (json["aiWaitTime"] != null) {
      ttsSetup.aiWaitTime = json['aiWaitTime'] as double;
    }
    return ttsSetup;
  }

  factory TTSSetup.defaultSetup() {
    return TTSSetup(
      voiceOption: 'no_voice',
      voiceGender: 'female',
      waitTime: 3,
      aiWaitTime: 10,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'voiceOption': voiceOption,
      'voiceGender': voiceGender,
      'waitTime': waitTime,
      'aiWaitTime': aiWaitTime,
    };
  }
}
