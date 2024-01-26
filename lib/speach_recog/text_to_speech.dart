
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

enum TtsState { playing, stopped, paused, continued }
class TTSUtils{

  TTSUtils._sharedInstance();
  static final TTSUtils _instance = TTSUtils._sharedInstance();
  factory TTSUtils() => _instance;


  /// Flutter TTS specific
  late FlutterTts flutterTts;
  String? language;
  String? engine;
  double volume = 0.8;
  double pitch = 1.0;
  double rate = 0.5;
  bool isCurrentLanguageInstalled = false;

  // String? _newVoiceText;
  int? _inputLength;

  Rx<TtsState> ttsState = Rx<TtsState>(TtsState.stopped);

  get isPlaying => ttsState == TtsState.playing;

  get isStopped => ttsState == TtsState.stopped;

  get isPaused => ttsState == TtsState.paused;

  get isContinued => ttsState == TtsState.continued;

  bool get isIOS => !kIsWeb && Platform.isIOS;

  bool get isAndroid => !kIsWeb && Platform.isAndroid;

  bool get isWeb => kIsWeb;

  get reco => null;

  initTts() {
    flutterTts = FlutterTts();

    flutterTts.setLanguage("en-IN");
    // flutterTts.setLanguage("en-US");
    _setAwaitOptions();

    if (isAndroid) {
      _getDefaultEngine();
    }

    flutterTts.setStartHandler(() {
      print("Playing");
      ttsState.value = TtsState.playing;
    });

    flutterTts.setCompletionHandler(() {
      print("Complete");
      ttsState.value = TtsState.stopped;
    });

    flutterTts.setCancelHandler(() {
      print("Cancel");
      ttsState.value = TtsState.stopped;
    });

    if (isWeb || isIOS) {
      flutterTts.setPauseHandler(() {
        print("Paused");
        ttsState.value = TtsState.paused;
      });

      flutterTts.setContinueHandler(() {
        print("Continued");
        ttsState.value = TtsState.continued;
      });
    }

    flutterTts.setErrorHandler((msg) {
      print("error: $msg");
      // ttsState.value = TtsState.stopped;
    });
  }

  Future<dynamic> _getLanguages() => flutterTts.getLanguages;

  Future<dynamic> _getEngines() => flutterTts.getEngines;

  Future _getDefaultEngine() async {
    var engine = await flutterTts.getDefaultEngine;
    if (engine != null) {
      print(engine);
    }
  }

  Future speak(String _newVoiceText) async {
    await flutterTts.setVolume(volume);
    await flutterTts.setSpeechRate(rate);
    await flutterTts.setPitch(pitch);

    if (_newVoiceText != null) {
      if (_newVoiceText.isNotEmpty) {
        await flutterTts.speak(_newVoiceText);
      }
    }
  }

  Future _setAwaitOptions() async {
    await flutterTts.awaitSpeakCompletion(true);
  }

  Future stop() async {
    var result = await flutterTts.stop();
    // if (result == 1) ttsState.value = TtsState.stopped;
  }

  Future pause() async {
    var result = await flutterTts.pause();
    // if (result == 1) ttsState.value = TtsState.paused;
  }

}