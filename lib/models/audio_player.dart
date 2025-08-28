import 'package:assets_audio_player/assets_audio_player.dart';

class AudioHelper {
  //create AudoPlayer object
  final AssetsAudioPlayer player = AssetsAudioPlayer();

  var sourcePath = '';

  open(String path) {
    sourcePath = path;
  }

  //play wav file from assets
  Future<void> playWav() async {
    await player.open(Audio(sourcePath), autoStart: true);
  }

  ///dispose player
  void dispose() {
    player.dispose();
  }
}
