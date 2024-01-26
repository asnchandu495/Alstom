import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:group_button/group_button.dart';
import 'package:photo_view/photo_view.dart';
import 'package:qandaapp/app_theme.dart';
import 'package:qandaapp/chatscreen/q_a_room.dart';
import 'package:qandaapp/models/user_model.dart';
import 'package:qandaapp/models/value_holder.dart';
import 'package:qandaapp/speach_recog/speach_recognation.dart';
import 'package:wakelock/wakelock.dart';

import '../customfunctionality/generate_chip.dart';
import '../customfunctionality/ui_factory.dart';
import '../models/custom_payload.dart';
import '../speach_recog/text_to_speech.dart';


class DiagramScreen extends StatefulWidget {

  static String routeChatRoom = '/ChatRoom';
  final String heading;
  final User user;

  const DiagramScreen({Key? key, required this.user, required this.heading})
      : super(key: key);

  @override
  _DiagramScreenState createState() => _DiagramScreenState();
}

class _DiagramScreenState extends State<DiagramScreen> {

  static String headerVal = "Inadequate air delivery at normal compressor working temperature.";
  static String subHeaderVal = "Inadequate air delivery at normal compressor working temperature. Air pressure is less than the normal range of 8-10 kg/cm2";

  static String subHeaderVal_Sound = "Inadequate air delivery at normal compressor working temperature. Air pressure is less than the normal range of 8-10 kg/cm2. Choose from the below options to continue";


  Function(String)? onDetectedValues;

  var bottomSheetTitle = "".obs;
  final RxList<S2Choice> _choiceValues = RxList();
  List<ValueHolderForBot> valueHolder = [];
  final RxList<String> _bottomSheetValueSelection = RxList();



  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    var options = Options();
    options.values = [];
    options.values!.add('Start');
    options.values!.add('Open Diagram');
    _choiceValues.value.add(S2Choice(label: 'Say ‘Ready’ to begin', meta: options));
    print('***************choicevalues  $_choiceValues.length');

    SpeechRecognizer().initSpeechState();
    TTSUtils().initTts();
    _speakAndListen(subHeaderVal_Sound);

    Wakelock.enable();
    SpeechRecognizer().counter = 0;

  }
  @override
  void dispose() {
    Wakelock.disable();
    TTSUtils().stop();
    SpeechRecognizer().cancelListening();
    // dialogFlowtter.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
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
                )),
            const SizedBox(
              width: 5,
            ),
            Text(
              widget.user.name,
              style: MyTheme.chatSenderName,
            )
          ],
        ),
        elevation: 4,
      ),
      backgroundColor: MyTheme.kWhite,
      //backgroundColor: Colors.grey[200],
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
                          height: 15,
                        ),
                        Container(
                          margin:  const EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0, bottom: 5.0),
                          child: Text(
                            headerVal,
                            style: MyTheme.diagramTitle,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Container(
                          margin:  const EdgeInsets.only(left: 20.0, right: 20.0, top: 5.0, bottom: 20.0),
                          child: Text(
                            subHeaderVal,
                            style: MyTheme.summaryValue,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Container(
                          // margin:  const EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0, bottom: 20.0),
                          alignment: Alignment.center,
                          child:
                          Image.asset(
                            'assets/images/mockupdiagram.png',
                            width: MediaQuery.of(context).size.width*0.5,
                            // height: (MediaQuery.of(context).size.width*0.5)/2,
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Align (
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
            //  Align(
            //   alignment: Alignment.bottomCenter,
            //   child: SpeechSampleApp(recognizedValue: (value){
            //
            //   },),
            // )
          ],
        ),
      ),

    );
  }

  _moveToQandARoom() {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => QandARoom(user: botSuMed,heading:widget.heading)));
  }

  final RxString recognizedWord = ''.obs;

  Widget _addToggle(int indexMain, String title, Options options)  {
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


          String valueToSend =holder.label + ' - ' + holder.value + "\n";

         // _bottomSheetValueSelection.clear();
           print("Sending values = $valueToSend");

           if (groupButtonController.selectedIndex == 0){
             _stopEverything();
             setState(() {
               _moveToQandARoom();
             });
           } else if (groupButtonController.selectedIndex == 1) {
             _stopEverything();
              showDialog(
                 context: context,
                 barrierDismissible: false,
                 builder: (context) {
                   return Container(
                     padding: const EdgeInsets.all(0),
                     child: Stack(
                       children: <Widget>[
                         PhotoView(
                           imageProvider:
                           const AssetImage("assets/images/motor_compressor.jpg"),
                         ),
                         Positioned(
                           top: 0,
                           right: 0,
                           child: GestureDetector(
                             onTap: (){
                               print('delete image from List');
                               setState((){
                                 print('set new state of images');
                                 //Navigator.of(context).pop();
                                 //SpeechRecognizer().startListening((p0) => onDetectedValues);
                                 SpeechRecognizer().initSpeechState();
                                 TTSUtils().initTts();
                                 _speakAndListen("Say start to continue");
                                 Navigator.pop(context);
                               }
                               );
                             },
                             child: const Icon(
                               Icons.clear,
                               color: Colors.white,
                               size: 30.0,
                             ),
                           ),
                         ),
                       ],
                     )

                   );
                   
                 }
                 );
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
            ]
        )
    );
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

      if (groupButtonController.selectedIndex == 0){
        _stopEverything();
        setState(() {
          _moveToQandARoom();
        });
      } else if (groupButtonController.selectedIndex == 1) {
        _stopEverything();
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return Container(
                  padding: const EdgeInsets.all(0),
                  child: Stack(
                    children: <Widget>[
                      PhotoView(
                        imageProvider:
                        const AssetImage("assets/images/motor_compressor.jpg"),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: (){
                            print('delete image from List');
                            setState((){
                              print('set new state of images');
                              //Navigator.of(context).pop();
                              //SpeechRecognizer().startListening((p0) => onDetectedValues);
                              SpeechRecognizer().initSpeechState();
                              TTSUtils().initTts();
                              _speakAndListen("Say start to continue");
                              Navigator.pop(context);
                            }
                            );
                          },
                          child: const Icon(
                            Icons.clear,
                            color: Colors.white,
                            size: 30.0,
                          ),
                        ),
                      ),
                    ],
                  )

              );

            }
        );
      }

    } else if (groupButtonController.selectedIndex == 2) {
      await _speakAndListen(title);
    } else {}
  }

  Future<void> _speakAndListen(String toSpeak) async {
    await TTSUtils().speak(toSpeak).whenComplete(() => SpeechRecognizer().startListening(onDetectedValues!));
  }

}
