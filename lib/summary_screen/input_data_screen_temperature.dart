import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:group_button/group_button.dart';
import 'package:qandaapp/LandingScreen/LandingScreen.dart';
import 'package:qandaapp/customfunctionality/custom_textfield.dart';
import 'package:qandaapp/customfunctionality/generate_chip.dart';
import 'package:qandaapp/customfunctionality/ui_factory.dart';
import 'package:qandaapp/models/custom_payload.dart';
import 'package:qandaapp/models/user_model.dart';
import 'package:qandaapp/models/value_holder.dart';
import 'package:qandaapp/speach_recog/speach_recognation.dart';
import 'package:qandaapp/speach_recog/text_to_speech.dart';
import 'package:qandaapp/summary_screen/summary_screen.dart';
import 'package:wakelock/wakelock.dart';

import '../app_theme.dart';

class InputDataScreenTemperature extends StatefulWidget {
  late final List _replicaBottomSheetValueSelection;
  late final Map _mapOfValuesSelection;
  late final VoidCallback _voidCallback;
  late final VoidCallback _resetCallback;

  InputDataScreenTemperature(this._replicaBottomSheetValueSelection,
      this._mapOfValuesSelection, this._voidCallback, this._resetCallback,
      {Key? key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => InputDataScreenTemperatureState();
}

class InputDataScreenTemperatureState
    extends State<InputDataScreenTemperature> {
  final String _nextTag = "Next";
  final String _repeatTag = 'Repeat';

  final String _temperatureTag = "Temperature Details";
  FocusNode _temperatureFocusNode = FocusNode();
  final Rx<TextEditingController> _temperatureController =
      Rx(TextEditingController());
  final RxList<S2Choice> _choiceValues = RxList();

  Function(String)? onDetectedValues;

  final String _readyTag = "Ready";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _temperatureFocusNode = FocusNode();
    var options = Options();
    options.values = [];
    options.values!.add(_repeatTag);
    options.values!.add(_nextTag);
    _choiceValues.value
        .add(S2Choice(label: 'Say ‘Ready’ to begin', meta: options));
    // _init();
    // _nowNext = false;
    Wakelock.enable();
    SpeechRecognizer().counter = 0;
    // _init();

    // FocusScope.of(context).requestFocus(_assetIdFocusNode);
    SchedulerBinding.instance!.addPostFrameCallback((timeStamp) {
      FocusScope.of(context).unfocus();
      Future.delayed(Duration(seconds: 1), () {
        _speakAndListen("Say $_readyTag to start", true);
      });
    });
  }

  @override
  void dispose() {
    _stopEverything();
    Wakelock.disable();
    super.dispose();
  }

  Future<void> _speakAndListen(String toSpeak, [bool addDelay = false]) async {
    await TTSUtils().speak(toSpeak);
    Future.delayed(Duration(milliseconds: addDelay ? 500 : 0), () {
      SpeechRecognizer().startListening(onDetectedValues!);
    });
  }

  _stopEverything() {
    SpeechRecognizer().counter = SpeechRecognizer().maxCounterValue;
    SpeechRecognizer().stopListening();
    SpeechRecognizer().cancelListening();
    TTSUtils().stop();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: Material(
        child: SafeArea(
          top: true,
          left: true,
          right: true,
          child: GestureDetector(
            onTap: () {
              // FocusScope.of(context).unfocus();
            },
            child: Stack(
              children: [
                Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width / 0.5,
                  height: MediaQuery.of(context).size.height / 1,
                  color: MyTheme.kBgColor,
                  // padding: EdgeInsets.all(20),
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: Card(
                      color: MyTheme.kWhite,
                      elevation: 10,
                      shadowColor: MyTheme.kBlueShade,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              _temperatureTag,
                              style: MyTheme.splashScreenTitle,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            color: MyTheme.kRedish,
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            height: 1,
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Obx(() => Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextField(
                                  controller: _temperatureController.value,
                                  focusNode: _temperatureFocusNode,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                      enabled: true,
                                      // helperText: 'Say Confirm to move next',
                                      labelText: _temperatureTag,
                                      border: OutlineInputBorder(),
                                      counterText: 'C'
                                      // counterText: 'counter'
                                      ),
                                ),
                              )),
                          const SizedBox(
                            height: 15,
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Obx(() {
                              int currentIndex = _choiceValues.length - 1;
                              Options options = Options();
                              var title = '';

                              if (currentIndex > -1) {
                                options =
                                    _choiceValues[currentIndex].meta as Options;
                                title = _choiceValues[currentIndex].label;
                              }
                              return Visibility(
                                  visible: _choiceValues.isNotEmpty,
                                  child: currentIndex > -1
                                      ? _addToggle(currentIndex, title, options)
                                      : const SizedBox(
                                          child: Text("DISPLAYING SIZED BOX"),
                                        ));
                            }),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              "Say $_readyTag to start.",
                              style: MyTheme.chatSenderName,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _moveToSummaryScreen(BuildContext context) {
    _stopEverything();
    widget._mapOfValuesSelection[_temperatureTag] =
        _temperatureTag + '-' + _temperatureController.value.text;

    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (_) => SummaryScreen(
                widget._replicaBottomSheetValueSelection,
                widget._mapOfValuesSelection,
                () {},
                () {})));
  }

  Widget _addToggle(int indexMain, String title, Options options) {
    GroupButtonController groupButtonController = GroupButtonController();
    RxList<bool> toggleSelectionOption =
        RxList(List.generate(options.values!.length, (index) => false));

    SpeechRecognizer().counter = 0;
    onDetectedValues = (recognizedValue) async {
      print("----------------STARTING TO LISTEN RECORDED $recognizedValue");

      bool isCommandFound = false;
      bool isReadyFound = false;
      bool isFound = false;
      var index = -1;
      // var value;
      for (var element in options.values!) {
        if (element.toLowerCase() == recognizedValue.toLowerCase()) {
          index = options.values!.indexOf(element);

          isCommandFound = true;

          /*  FocusScope.of(context).unfocus();*/
          groupButtonController.selectIndex(index);
          groupButtonController.notifyListeners();

          print("------- COMMAND FOUND and index = $index");
          break;
        }
      }

      if (recognizedValue.toLowerCase() == _readyTag.toLowerCase()) {
        isFound = false;
        _makeRepeatWork();
      } else if (_temperatureFocusNode.hasFocus && !isCommandFound) {
        recognizedValue = recognizedValue.replaceAll(new RegExp(r'[^0-9]'), '');

        // if (GetUtils.isNumericOnly(recognizedValue.removeAllWhitespace)) {
        try {
          int value = int.parse(recognizedValue);
          print("----------------Integer value $value");

          isFound = true;
          _temperatureController.value.text = recognizedValue;
          // _pressureFocusNode.requestFocus();
          SpeechRecognizer().counter = 0;
          /*FocusScope.of(context).unfocus();*/
          _speakAndListen(
              "You have provided $recognizedValue, Say Next to confirm");
        } on Exception catch (e) {
          // TODO
        }
      } else if (isCommandFound) {
        print("----------------isELEMENT FOUND $isCommandFound");

        SpeechRecognizer().stopListening();

        groupButtonController.selectIndex(index);
        groupButtonController.notifyListeners();

        var value = options.values![index];
        if (groupButtonController.selectedIndex == 0 ||
            groupButtonController.selectedIndex == 1) {
          var holder = ValueHolderForBot();
          holder.label = title;
          holder.value = value;
          await TTSUtils().speak("You have selected $value");

          String valueToSend = holder.label + ' - ' + holder.value + "\n";

          // _bottomSheetValueSelection.clear();
          print("Sending values = $valueToSend");

          if (groupButtonController.selectedIndex == 0) {
            _makeRepeatWork();
          } else if (groupButtonController.selectedIndex == 1) {
            _stopEverything();
            _moveToSummaryScreen(context);
          }
        }
      } else {
        _speakAndListen(
            "I am having problem understanding, can you please say again!");
      }
    };
    //_speakAndListen(headerVal);
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              /*getSubtitleWidget(title),*/
              const SizedBox(height: 5),
              getToggleWidget(title, toggleSelectionOption, options, indexMain,
                  (mainIndex, value) async {
                _handleButtonSelection(
                    groupButtonController, title, value, mainIndex);
              }, groupButtonController),
            ]));
  }

  _handleButtonSelection(GroupButtonController groupButtonController,
      String title, String value, int mainIndex) async {
    print(
        "Groupbutton selected index = ${groupButtonController.selectedIndex}");
    if (groupButtonController.selectedIndex == 0 ||
        groupButtonController.selectedIndex == 1) {
      var holder = ValueHolderForBot();
      holder.label = title;
      holder.value = value;
      // await TTSUtils().speak("You have selected $value");

      String valueToSend = holder.label + ' - ' + holder.value + "\n";

      // _bottomSheetValueSelection.clear();
      print("Sending values = $valueToSend");

      if (groupButtonController.selectedIndex == 0) {
        _makeRepeatWork();
      } else if (groupButtonController.selectedIndex == 1) {
        _stopEverything();
        _moveToSummaryScreen(context);
      }
    } else if (groupButtonController.selectedIndex == 2) {
      await _speakAndListen(title);
    } else {}
  }

  void _makeRepeatWork() {
    _speakAndListen(_temperatureTag);
    _temperatureController.value.text = '';
    // setState(() {
    FocusScope.of(context).requestFocus(_temperatureFocusNode);
    // });
  }
}
