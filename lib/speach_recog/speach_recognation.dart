import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:qandaapp/speach_recog/text_to_speech.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechRecognizer {
  SpeechRecognizer._sharedInstance();

  static final SpeechRecognizer _instance = SpeechRecognizer._sharedInstance();

  factory SpeechRecognizer() => _instance;

  Function(String)? onDetectedValues;
  RxBool _hasSpeech = RxBool(false);
  bool _logEvents = true;
  double level = 0.0;
  double minSoundLevel = 50000;
  double maxSoundLevel = -50000;
  String lastWords = '';
  String lastError = '';
  String lastStatus = '';
  String _currentLocaleId = '';
  List<LocaleName> _localeNames = [];
  final SpeechToText speech = SpeechToText();

  late BuildContext localContext;

  bool selectedRadio = false;
  int counter = 0;
  final int maxCounterValue = 3;

  void _logEvent(String eventDescription) {
    if (_logEvents) {
      var eventTime = DateTime.now().toIso8601String();
      print('$eventTime $eventDescription');
    }
  }

  Future<void> initSpeechState() async {
    _logEvent('Initialize');
    try {
      var hasSpeech = await speech.initialize(
          onError: errorListener,
          onStatus: statusListener,
          debugLogging: false,
          finalTimeout: Duration(milliseconds: 10));
      if (hasSpeech) {
        // Get the list of languages installed on the supporting platform so they
        // can be displayed in the UI for selection by the user.
        _localeNames = await speech.locales();

        var systemLocale = await speech.systemLocale();
        _currentLocaleId = systemLocale?.localeId ?? '';
      }
      // if (!mounted) return;

      // setState(() {
      _hasSpeech.value = hasSpeech;

      // });
    } catch (e) {
      // setState(() {
      lastError = 'Speech recognition failed: ${e.toString()}';
      print("********** $lastError");
      _hasSpeech.value = false;
      // });
    }
  }

  Future<void> startListening(Function(String) onRecognize) async {
    _logEvent('start listening');
    lastWords = '';
    lastError = '';
    onDetectedValues = onRecognize;
    // Note that `listenFor` is the maximum, not the minimun, on some
    // recognition will be stopped before this value is reached.
    // Similarly `pauseFor` is a maximum not a minimum and may be ignored
    // on some devices.
    await speech.listen(
        onResult: (SpeechRecognitionResult result) async {
          _logEvent(
              'Result listener final: ${result.finalResult}, words: ${result.recognizedWords}');
          //  setState(() {
          lastWords = '${result.recognizedWords} - ${result.finalResult}';
          // print(lastWords);
          // print(result.finalResult);
          // print(result.recognizedWords);
          if (result.finalResult) {
            counter = 0;
            onDetectedValues!.call(result.recognizedWords);
          }
          /*else{
            await _speak("Please try again");
            startListening(onRecognize);
          }*/

          _hasSpeech.value = true;
        },
        // listenFor: const Duration(seconds: 30),
        // pauseFor: const Duration(seconds: 5),
        listenFor: const Duration(seconds: 10),
        pauseFor: const Duration(seconds: 5),
        partialResults: true,
        localeId: _currentLocaleId,
        onSoundLevelChange: soundLevelListener,
        cancelOnError: false,
        listenMode: ListenMode.dictation);
  }

  void stopListening() {
    _logEvent('stop');
    speech.stop();
    // setState(() {
    level = 0.0;
    // });
  }

  void cancelListening() {
    _logEvent('cancel');
    speech.cancel();
    // setState(() {
    level = 0.0;
    // });
  }

  void testAlert(BuildContext context) {
    var alert = const AlertDialog(
      title: Text("Test"),
      content: Text("Done..!"),
    );

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        });
  }

  void soundLevelListener(double level) {
    minSoundLevel = min(minSoundLevel, level);
    maxSoundLevel = max(maxSoundLevel, level);
    // _logEvent('sound level $level: $minSoundLevel - $maxSoundLevel ');
    // setState(() {
    this.level = level;
    // });
  }

  Future<void> errorListener(SpeechRecognitionError error) async {
    _logEvent(
        'Received error status: $error, listening: ${speech.isListening} @ ${DateTime.now().toString()}');

    lastError = '${error.errorMsg} - ${error.permanent}';
    // stopListening();
    _hasSpeech.value = true;

    // startListening(onDetectedValues!);

    if (counter < maxCounterValue) {
      Future.delayed(Duration(milliseconds: 1000), () {
        cancelListening();
      });
      Future.delayed(Duration(milliseconds: 2500), () {
        startListening(onDetectedValues!);
        counter++;
      });

      // await _speakAndListen("I haven't catch it, can you please speak again!");
    } else {
      TTSUtils()
          .speak("I am not able to understand, Please use screen selection");
    }
  }

  void statusListener(String status) {
    _logEvent(
        'Received listener status: $status, listening: ${speech.isListening}');

    lastStatus = status;
  }
}
