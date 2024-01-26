// import 'package:awesome_select/awesome_select.dart';
import 'dart:io';
import 'dart:math';
import 'package:dialog_flowtter/dialog_flowtter.dart' as dialogFlow;
import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

import 'package:get/get.dart';
import 'package:group_button/group_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:photo_view/photo_view.dart';
import 'package:qandaapp/customfunctionality/generate_chip.dart';
import 'package:qandaapp/customfunctionality/ui_factory.dart';
import 'package:qandaapp/models/custom_payload.dart';
import 'package:qandaapp/models/message_model.dart' as appMessage;
import 'package:qandaapp/models/message_model.dart';
import 'package:qandaapp/models/value_holder.dart';
import 'package:qandaapp/speach_recog/speach_recognation.dart';
import 'package:qandaapp/speach_recog/text_to_speech.dart';
import 'package:qandaapp/summary_screen/input_data_screen.dart';
import 'package:qandaapp/summary_screen/summary_screen.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:wakelock/wakelock.dart';

import '../app_theme.dart';
import 'package:flutter/material.dart';

import '../models/user_model.dart';
import '../customfunctionality/generate_chip.dart';

/*
Layout type
0 -> Single select chip
1 -> Multi selected chip
2 -> List selection chip

options (when there is list)
1 - > First option and it increase its value for rest of option
 */
class QandARoom extends StatefulWidget {
  static String routeChatRoom = '/ChatRoom';
  final String heading;

  const QandARoom({Key? key, required this.user, required this.heading})
      : super(key: key);

  @override
  _QandARoomState createState() => _QandARoomState();
  final User user;
}



class _QandARoomState extends State<QandARoom> /*with RestorationMixin*/ {
  late dialogFlow.DialogFlowtter dialogFlowtter;
  var msgController = Get.put(MessageController());
  Function(String)? onDetectedValues;

  // var isBottomSheetShow = false.obs;
  var bottomSheetTitle = "".obs;
  RxList<String> _bottomSheetValueSelection = RxList();
  RxList<String> _replicaBottomSheetValueSelection = RxList();
  Map<String, String> _mapOfValuesSelection = {};
  RxList<String> _multipleValueQueue = RxList();

  final RxList<S2Choice> _choiceValues = RxList();
  bool _isSingleSelection = false;
  int? _layoutType = 0;
  bool _isForName = false;
  List<ValueHolderForBot> valueHolder = [];
  Map<String, Options> mapOptions = {};
  final RxBool _isWaitForAnotherMessage = false.obs;


  // RecorderStream _recorder = RecorderStream();
  // PlayerStream _player = PlayerStream();
  // StreamSubscription? _recorderStatus;
  // StreamSubscription<List<int>>? _audioStreamSubscription;
  // BehaviorSubject<List<int>>? _audioStream;

  @override
  void dispose() {
    Wakelock.disable();
    TTSUtils().stop();
    SpeechRecognizer().cancelListening();
    dialogFlowtter.dispose();
    super.dispose();
  }

  /// ENDS Flutter TTS specific


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    dialogFlow.DialogFlowtter.fromFile().then((instance) {
      dialogFlowtter = instance;
      _initConversation();
      TTSUtils().initTts();
     SpeechRecognizer().initSpeechState();
/*      Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => InputDataScreen(RxList(), {},(){},(){})
            // QandARoom(user: botSuMed,heading: title,)
          ));*/
    });
    Wakelock.enable();
    SpeechRecognizer().counter = 0;

/*    Future.delayed(const Duration(seconds: 2), () {
      initSpeechState();
    });*/

    _choiceValues.listen((message) {
      // var options = _choiceValues.last.labelmeta as Options;
      if (message.isNotEmpty) {
        _message.value = message.last.label;
        print("-------------${_message.value}");
      }
    });

    bottomSheetTitle.listen((p0) {
      if (p0.toLowerCase().contains("summary")) {
        _stopEverything();
        print("-----------Received value = $p0");
        // stopListening();
        // _moveToSummaryScreen();
      }
    });
    // initSpeechState();
  }

  _moveToSummaryScreen() {


    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (_) => InputDataScreen(
                    _replicaBottomSheetValueSelection, _mapOfValuesSelection,
                    () {
                  /*    SpeechRecognizer().startListening((p0) => onDetectedValues);*/

                }, () {
              /*SpeechRecognizer().startListening((p0) => onDetectedValues);
                  _replicaBottomSheetValueSelection.clear();
                  _mapOfValuesSelection.clear();*/
                })));
  }

  _initConversation() async {
    await _checkForMessage("Q&A");
  }


  List<String> determineMessageType(dialogFlow.Message message) {
    List<String> values = [];
    switch (message.type) {
      case dialogFlow.MessageType.payload:
        if (message.payload != null) {
          values.add("1");
          var parsedValue = _parsePayload(message.payload!);
          int type = parsedValue['op'];
          values.addAll(parsedValue['values']);

          _isSingleSelection = type < 2;
          print("**********is Single selection $_isSingleSelection");
        }
        return values;
      /*case dialogFlow.MessageType.card:
      // return _CardContainer(card: message.card!);
        break;*/
      case dialogFlow.MessageType.text:
      default:
        values.add("0");
        values.add(message.text?.text?[0] ?? '');
        return values;
    }
  }

  Map<String, dynamic> _parsePayload(Map<String, dynamic> payload) {
    final Map<String, dynamic> map = {};
    final List<String> values = [];

    CustomPayload receivedPayload = CustomPayload.fromJson(payload);
    /*if (!_isCalled) {
      onExtraMessage.call(receivedPayload.contentTitle!);
      _isCalled = true;
    }*/
    int type = receivedPayload.outputValue!;
    _layoutType = receivedPayload.layoutType;
    map["op"] = type;
    values.add(receivedPayload.contentTitle!);
    for (var element in receivedPayload.richContent!) {
      for (var innerElement in element) {
        if (innerElement.type! == "list") values.add(innerElement.title!);
        if (innerElement.options != null) {
          mapOptions[innerElement.title!] = innerElement.options!;
        }
      }
    }

    map["values"] = values;
    if (mapOptions.isNotEmpty && _layoutType == 2) map["options"] = mapOptions;

    return map;
  }

  Future<void> _checkForMessage(text, [bool isUserMessage = false]) async {
    dialogFlow.DetectIntentResponse response =
        await dialogFlowtter.detectIntent(
      queryInput: dialogFlow.QueryInput(text: dialogFlow.TextInput(text: text)),
    );

    // print("RECEIVED TEXT = ${response.props.toString()}");
    if (response.message == null) return;

    // msgController.messages
    _addMessage(response.message!, isUserMessage);

    if (_isWaitForAnotherMessage.value) {
      _isWaitForAnotherMessage.value = false;
      // _isWaitForAnotherMessage.value = true;
      if (_multipleValueQueue.isEmpty) {
        // _isWaitForAnotherMessage.value = false;
        _multipleValueQueue.close();
      }
    }
    _botStatus.value = _online;
  }

  Future<void> _addMessage(dialogFlow.Message message,
      [bool isUserMessage = false, bool isDisplay = true]) async {
    // print("********** ${message.toString()}");
    String textToDisplay = "";
    if (!isUserMessage) {
      List<String> values = determineMessageType(message);
      String typeOfMessage = values.removeAt(0);
      textToDisplay = values.removeAt(0);
      bottomSheetTitle.value = textToDisplay;

      if (values.isNotEmpty) {
        _choiceValues.clear();
        for (var element in values) {
          _choiceValues.add(S2Choice(
              label: element,
              meta: _layoutType == 2 && mapOptions.isNotEmpty
                  ? mapOptions[element]
                  : ""));
        }
        // isBottomSheetShow.value = true;
        bottomSheetTitle.value = textToDisplay;

        // _determineInputLayout();
      }
    } else {
      textToDisplay = message.text!.text![0].toString();
    }

    if (isDisplay) _addMessageToConversation(isUserMessage, textToDisplay);
  }

  String _getTimeValue() {
    final df = DateFormat('hh:mm a');
    return df.format(DateTime.fromMillisecondsSinceEpoch(
        DateTime.now().millisecondsSinceEpoch));
  }

  Future<void> _sendMessage(String text, [bool isDisplay = true]) async {
    if (text.isEmpty) return;

    await Future.delayed(const Duration(milliseconds: 500), () {
      _addMessage(dialogFlow.Message(text: dialogFlow.DialogText(text: [text])),
          true, isDisplay);
      _checkForMessage(text) /*.whenComplete(() => func.call())*/;
    });
  }

  final String _online = 'Online';
  final String _typing = 'Typing...';
  final RxString _botStatus = ''.obs;
  final RxString _message = ''.obs;
  final RxString recognizedWord = ''.obs;
  GlobalKey keyForFAB = GlobalKey();

  @override
  Widget build(BuildContext context) {
    _botStatus.value = _online;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyTheme.kAppbarColor,
        centerTitle: false,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CircleAvatar(
                radius: 24,
                backgroundColor: MyTheme.kAppbarColor,
                child: Image.asset(
                  widget.user.avatar,
                  // height: 24,
                  // width: 24,
                )),
            const SizedBox(
              width: 5,
            ),
            Text(
              widget.user.name,
              style: MyTheme.chatSenderName,
            )
            /*Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.user.name,
                  style: MyTheme.chatSenderName,
                ),
                Flex(direction: Axis.horizontal, children: [
                  const Icon(
                    Icons.fiber_manual_record,
                    color: Colors.green,
                    size: 12,
                  ),
                  Obx(() {
                    return Text(
                      _botStatus.value,
                      style: MyTheme.chatTime,
                    );
                  })
                ]),
              ],
            ),*/
          ],
        ),
        elevation: 4,
      ),
      backgroundColor: MyTheme.kBgColor,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
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
                padding: EdgeInsets.all(8),
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
                          widget.heading,
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
                        height: 20,
                      ),
                      Obx(() {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Text(
                            _message.value,
                            textAlign: TextAlign.center,
                            style: MyTheme.screenTitle,
                          ),
                        );
                      }),
                      const SizedBox(
                        height: 110,
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

                          print(
                              "------------------EXECUTING index = $currentIndex and Title = $title and Choice value empty = ${_choiceValues.isNotEmpty}");

                          return Visibility(
                              visible: _choiceValues.isNotEmpty,
                              child: currentIndex > -1
                                  ? _addToggle(currentIndex, title, options)
                                  : const SizedBox(
                                      child: Text("DISPLAYING SIZED BOX"),
                                    ));
                        }),
                      )
                    ],
                  ),
                ),
              ),
            ),
            /* Align(
              alignment: Alignment.bottomCenter,
              child: SpeechSampleApp(recognizedValue: (value){

              },),
            )*/
          ],
        ),
      ),
      /*floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await showDialog(
              context: context,
              builder: (context) {
                return PhotoView(
                  imageProvider:
                      const AssetImage("assets/images/motor_compressor.jpg"),
                );
              });
          startListening((p0) => onDetectedValues);
        },
        key: keyForFAB,
        child: Icon(
          Icons.image,
          color: MyTheme.kWhite,
        ),
        heroTag: "show diagram",
        tooltip: "Show diagram",
      ),*/
    );
  }

  bool _isAskForDiagram(String word) {
    var fab = keyForFAB.currentContext!.widget as FloatingActionButton;
    var tag = fab.heroTag.toString();
    bool isAsked = tag.toLowerCase() == word.toLowerCase();

    if (isAsked) fab.onPressed!.call();
    return isAsked;
  }

  void _addMessageToConversation(bool isUserMessage, String textToDisplay) {
    var appMsgs = appMessage.Message(
        sender: isUserMessage ? currentUser : botSuMed,
        avatar: isUserMessage ? currentUser.avatar : botSuMed.avatar,
        text: textToDisplay,
        time: _getTimeValue(),
        isRead: true,
        unreadCount: 0);
    if (!isUserMessage)
      msgController.chatMessageHolder /*.value .value*/ .add(appMsgs);
  }

  Widget _addToggle(int indexMain, String title, Options options) {
    GroupButtonController groupButtonController = GroupButtonController();
    RxList<bool> toggleSelectionOption =
        RxList(List.generate(options.values!.length, (index) => false));
    SpeechRecognizer().counter = 0;
    onDetectedValues = (recognizedValue) async {
      print("----------------STARTING TO LISTEN RECORDED $recognizedWord");
      /*bool isForDiagram = _isAskForDiagram(recognizedValue);
      if (isForDiagram) {
        return;
      }*/
      bool isFound = false;
      var index = -1;
      var value;
      for (var element in options.values!) {
        if (element.toLowerCase() == recognizedValue.toLowerCase()) {
          index = options.values!.indexOf(element);
          if (index != 3) {
            isFound = true;
            break;
          }
        }
      }
      print("----------------isELEMENT FOUND $isFound");

      if (isFound) {
        SpeechRecognizer().stopListening();
        groupButtonController.selectIndex(index);
        groupButtonController.notifyListeners();
        value = options.values![index];

        if (groupButtonController.selectedIndex == 0 ||
            groupButtonController.selectedIndex == 1) {
          var holder = ValueHolderForBot();
          holder.label = title;
          holder.value = value;
          await TTSUtils().speak("You have selected $value");
          try {
            ValueHolderForBot? botValue = valueHolder.elementAt(indexMain);
            if (botValue != null) {
              valueHolder.removeAt(indexMain);
            }
          } catch (e) {}
          valueHolder.insert(indexMain, holder);

          String valueToSend =holder.label + ' - ' + holder.value + "\n";

          _bottomSheetValueSelection.clear();

          // _choiceValues.clear();
          var valueToDisplay = valueToSend;
          bool isExeeded = valueToSend.length > 255;
          if (isExeeded) {
            valueToSend = valueToSend.substring(0, 255);
            // _addMessageToConversation(true, valueToDisplay);
          }
          print("Sending values = $valueToSend");

          // Future.delayed(Duration(seconds: 1), () async {
          await _sendMessage(valueToSend, false);
          // });

          _mapOfValuesSelection[bottomSheetTitle.value] = valueToDisplay;
          if (groupButtonController.selectedIndex == 0 &&
              value.toLowerCase().contains("camera")) {
            _stopEverything();
            ValueHolderForBot bot = valueHolder[indexMain];
            valueHolder.remove(bot);
            bot.label = bot.label;
            bot.value = "Picture Taken";
            valueHolder.insert(indexMain, bot);
            String valueToSend = bot.label + ' - ' + bot.value + "\n";
           _mapOfValuesSelection[bottomSheetTitle.value] = valueToSend;
            _stopEverything();
           // await ImagePicker()
            //    .pickImage(source: ImageSource.camera, imageQuality: 90);

            File imgFile;
            var imgPicker =  await ImagePicker()
                .pickImage(source: ImageSource.camera, imageQuality: 90);
            setState(() {
              _stopEverything();
              var imgFile = File(imgPicker!.path);
              if (imgFile == null){
                print('Image object is nil');

              } else {
                print('Image fetched');

              }

              _moveToSummaryScreen();

            });

          }
        } else if (groupButtonController.selectedIndex == 2) {
          await _speakAndListen(title);
        }

        // startListening((p0) => this);

      } else {
        _speakAndListen(
            "I am having problem understanding, can you please say again!");
      }
    };
    _speakAndListen(title);
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
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

  _stopEverything() {
    SpeechRecognizer().counter = SpeechRecognizer().maxCounterValue;
    SpeechRecognizer().stopListening();
    SpeechRecognizer().cancelListening();
    TTSUtils().stop();
  }

  _errorMessageCase(
      [String message =
          "I am having problem understanding, can you please say again!"]) async {
    SpeechRecognizer(). stopListening();
    print(
        "----------------LISTENING HAS BEEN STOPPED ${DateTime.now().toString()}");
    await TTSUtils().speak(message);
    print("----------------RESTARTING LISTENING ${DateTime.now().toString()}");
    SpeechRecognizer().startListening((p0) => onDetectedValues);
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
      try {
        ValueHolderForBot? botValue = valueHolder.elementAt(mainIndex);
        if (botValue != null) {
          valueHolder.removeAt(mainIndex);
        }
      } catch (e) {}
      valueHolder.insert(mainIndex, holder);
      String valueToSend =
           holder.label + ' - ' + holder.value + "\n";

      _bottomSheetValueSelection.clear();

      // _choiceValues.clear();
      var valueToDisplay = valueToSend;
      bool isExeeded = valueToSend.length > 255;
      if (isExeeded) {
        valueToSend = valueToSend.substring(0, 255);
        // _addMessageToConversation(true, valueToDisplay);
      }
      // print("Sending values = $valueToSend");
      SpeechRecognizer().counter = 0;
      await _sendMessage(valueToSend, false);
      _mapOfValuesSelection[bottomSheetTitle.value] = valueToDisplay;
      if (groupButtonController.selectedIndex == 0 &&
          value.toLowerCase().contains("camera")) {
        _stopEverything();
        ValueHolderForBot bot = valueHolder[mainIndex];
        valueHolder.remove(bot);
        bot.label = bot.label;
        bot.value = "Picture Taken";
        valueHolder.insert(mainIndex, bot);
        String valueToSend = bot.label + ' - ' + bot.value + "\n";
        _mapOfValuesSelection[bottomSheetTitle.value] = valueToSend;
        File imgFile;

        var imgPicker =  await ImagePicker()
            .pickImage(source: ImageSource.camera, imageQuality: 90);
        setState(() {
          _stopEverything();
          var imgFile = File(imgPicker!.path);
          if (imgFile == null){
            print('image object is nil');

          } else {
            print('image fetched');

          }
          _moveToSummaryScreen();
        });
      }
    } else if (groupButtonController.selectedIndex == 2) {
      await _speakAndListen(title);
    } else {}
  }

  Future<void> _speakAndListen(String toSpeak) async {
    await TTSUtils().speak(toSpeak).whenComplete(() => SpeechRecognizer().startListening(onDetectedValues!));
  }

/*@override
  String? get restorationId => 'chat_room';

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(msgController.chatMessageHolder.value, 'chat_conversation');
  }*/
}
