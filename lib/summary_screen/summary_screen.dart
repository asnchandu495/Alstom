import 'dart:ffi';

import 'package:dialog_flowtter/dialog_flowtter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qandaapp/LandingScreen/LandingScreen.dart';
import 'package:qandaapp/models/user_model.dart';

import '../app_theme.dart';

class SummaryScreen extends StatefulWidget{

  late final List _replicaBottomSheetValueSelection;
  late final Map _mapOfValuesSelection;
  late final VoidCallback _voidCallback;
  late final VoidCallback _resetCallback;

  SummaryScreen(this._replicaBottomSheetValueSelection,
      this._mapOfValuesSelection, this._voidCallback, this._resetCallback,
      {Key? key})
      : super(key: key);

  @override
  SummaryScreenState createState() => SummaryScreenState(this._replicaBottomSheetValueSelection, this._mapOfValuesSelection, this._voidCallback, this._resetCallback);

}


class SummaryScreenState extends State<SummaryScreen> {
  late final List _replicaBottomSheetValueSelection;
  late final Map _mapOfValuesSelection;
  late final VoidCallback _voidCallback;
  late final VoidCallback _resetCallback;

  bool _visible = false; // in top of your class


  SummaryScreenState(this._replicaBottomSheetValueSelection,
      this._mapOfValuesSelection, this._voidCallback, this._resetCallback,
      {Key? key});

  String retunListFirstValues(int indexVale) {
    final split = _mapOfValuesSelection.values.elementAt(indexVale).split('-');
    final Map<int, String> values = {
      for (int i = 0; i < split.length; i++) i: split[i]
    };
    return values[0].toString();
  }

  bool returnHiddenValue() {

    bool isValid = false;
    Future.delayed(const Duration(seconds: 12), () { //asynchronous delay
     // setState(() {
        isValid = true;
        return isValid;
    ///  });
    });

    return isValid;
  }

  String retunListSecondValues(int indexVale) {
    final split = _mapOfValuesSelection.values.elementAt(indexVale).split('-');
    final Map<int, String> values = {
      for (int i = 0; i < split.length; i++) i: split[i]
    };
    return values[1].toString();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: Material(
        child: Stack(
          children: [
            Container(
                color: MyTheme.kWhite,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    switch (index) {
                      /*       case 1:
                        return Stack(children: [
                          Container(
                              decoration:
                                  BoxDecoration(color: MyTheme.kSummaryLightShade),
                              child: ListTile(
                                tileColor: MyTheme.kSummaryLightShade,
                                title: Text("${currentUser.name}'s symptoms",
                                    style: MyTheme.summaryCaption),
                                style: ListTileStyle.drawer,
                              )),
                          Align(
                              alignment: Alignment.centerRight,
                              child: Row(mainAxisSize: MainAxisSize.min,
                                  // mainAxisAlignment: MainAxisAlignment.end,
                                  // crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: IconButton(
                                          onPressed: () {
                                            Get.back();
                                            _resetCallback.call();
                                          },
                                          icon: Icon(
                                            Icons.refresh,
                                            color: MyTheme.kRedish,
                                          )),
                                    ),
                                    Align(
                                        alignment: Alignment.centerRight,
                                        child: IconButton(
                                            onPressed: () {
                                              Get.back();
                                              _voidCallback.call();
                                            },
                                            icon: Icon(
                                              Icons.schedule,
                                              color: MyTheme.kRedish,
                                            )))
                                  ]))
                        ]);
                      case 2:
                        return Container(
                            decoration:
                                BoxDecoration(color: MyTheme.kSummaryDarkShade),
                            child: ListTile(
                              title: const Text("Observed symptoms",
                                  style: MyTheme.summaryCaption),
                              subtitle: Text(
                                _replicaBottomSheetValueSelection.toString(),
                                style: MyTheme.summaryValue,
                              ),
                              style: ListTileStyle.drawer,
                            ));*/
                      case 1:
                        return Column(
                          children: <Widget>[
                            Container(
                                decoration:
                                    BoxDecoration(color: Color(0xffd12d4f)),
                                child: IntrinsicHeight(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                          flex: 7,
                                          child: Container(
                                            margin: const EdgeInsets.only(
                                                left: 10.0,
                                                right: 10.0,
                                                bottom: 10.0,
                                                top: 10.0),
                                            child: Text(
                                              "Instuctions",
                                              style: MyTheme.summaryCaption
                                                  .copyWith(
                                                      color: MyTheme.kWhite),
                                              textAlign: TextAlign.center,
                                            ),
                                          )),
                                      // Container(color: Colors.black,  width: 0.8),
                                      const VerticalDivider(
                                          thickness: 1.0, color: Colors.grey),
                                      Expanded(
                                          flex: 3,
                                          child: Container(
                                            margin: const EdgeInsets.only(
                                                left: 10.0,
                                                right: 10.0,
                                                bottom: 10.0,
                                                top: 10.0),
                                            child: Text(
                                              "Status",
                                              style: MyTheme.summaryCaption
                                                  .copyWith(
                                                      color: MyTheme.kWhite),
                                              textAlign: TextAlign.center,
                                            ),
                                          )),
                                    ],
                                  ),
                                )),
                            Container(
                                decoration: BoxDecoration(
                                    color: MyTheme.kSummaryLightShade),
                                child: IntrinsicHeight(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                          flex: 7,
                                          child: Container(
                                            margin: const EdgeInsets.only(
                                                left: 10.0,
                                                right: 10.0,
                                                bottom: 10.0,
                                                top: 10.0),
                                            child: Text(
                                              retunListFirstValues(0)
                                                  .toString(),
                                              style: MyTheme.summaryCaption,
                                            ),
                                          )),
                                      // Container(color: Colors.black,  width: 0.8),
                                      const VerticalDivider(
                                          thickness: 1.0, color: Colors.grey),
                                      Expanded(
                                          flex: 3,
                                          child: Container(
                                            margin: const EdgeInsets.only(
                                                left: 10.0,
                                                right: 10.0,
                                                bottom: 10.0,
                                                top: 10.0),
                                            child: Text(
                                              retunListSecondValues(0)
                                                  .toString(),
                                              style: MyTheme.summaryCaption,
                                              textAlign: TextAlign.center,
                                            ),
                                          )),
                                    ],
                                  ),
                                ))
                          ],
                        );

                      case 2:
                        return Container(
                            decoration:
                                BoxDecoration(color: MyTheme.kSummaryDarkShade),
                            child: IntrinsicHeight(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                      flex: 7,
                                      child: Container(
                                        margin: const EdgeInsets.only(
                                            left: 10.0,
                                            right: 10.0,
                                            bottom: 10.0,
                                            top: 10.0),
                                        child: Text(
                                          retunListFirstValues(1).toString(),
                                          style: MyTheme.summaryCaption,
                                        ),
                                      )),
                                  // Container(color: Colors.black,  width: 0.8),
                                  const VerticalDivider(
                                      thickness: 1.0, color: Colors.grey),
                                  Expanded(
                                      flex: 3,
                                      child: Container(
                                        margin: const EdgeInsets.only(
                                            left: 10.0,
                                            right: 10.0,
                                            bottom: 10.0,
                                            top: 10.0),
                                        child: Text(
                                          retunListSecondValues(1).toString(),
                                          style: MyTheme.summaryCaption,
                                          textAlign: TextAlign.center,
                                        ),
                                      )),
                                ],
                              ),
                            )
                            /*
                            ListTile(
                              tileColor: MyTheme.kSummaryLightShade,
                              title: Text(
                                  _mapOfValuesSelection.values.elementAt(1),
                                  style: MyTheme.summaryCaption
                              ),
                              /*subtitle: Text(
                                _mapOfValuesSelection.values.elementAt(1),
                                style: MyTheme.summaryValue,
                              ),*/
                              style: ListTileStyle.drawer,
                            )
                            */
                            );
                      case 3:
                        return Container(
                            decoration: BoxDecoration(
                                color: MyTheme.kSummaryLightShade),
                            child: IntrinsicHeight(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                      flex: 7,
                                      child: Container(
                                        margin: const EdgeInsets.only(
                                            left: 10.0,
                                            right: 10.0,
                                            bottom: 10.0,
                                            top: 10.0),
                                        child: Text(
                                          retunListFirstValues(2).toString(),
                                          style: MyTheme.summaryCaption,
                                        ),
                                      )),
                                  // Container(color: Colors.black,  width: 0.8),
                                  const VerticalDivider(
                                      thickness: 1.0, color: Colors.grey),
                                  Expanded(
                                      flex: 3,
                                      child: Container(
                                        margin: const EdgeInsets.only(
                                            left: 10.0,
                                            right: 10.0,
                                            bottom: 10.0,
                                            top: 10.0),
                                        child: Text(
                                          retunListSecondValues(2).toString(),
                                          style: MyTheme.summaryCaption,
                                          textAlign: TextAlign.center,
                                        ),
                                      )),
                                ],
                              ),
                            ));
                      case 4:
                        return Container(
                            decoration:
                                BoxDecoration(color: MyTheme.kSummaryDarkShade),
                            child: IntrinsicHeight(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                      flex: 7,
                                      child: Container(
                                        margin: const EdgeInsets.only(
                                            left: 10.0,
                                            right: 10.0,
                                            bottom: 10.0,
                                            top: 10.0),
                                        child: Text(
                                          retunListFirstValues(3).toString(),
                                          style: MyTheme.summaryCaption,
                                        ),
                                      )),
                                  // Container(color: Colors.black,  width: 0.8),
                                  const VerticalDivider(
                                      thickness: 1.0, color: Colors.grey),
                                  Expanded(
                                      flex: 3,
                                      child: Container(
                                        margin: const EdgeInsets.only(
                                            left: 10.0,
                                            right: 10.0,
                                            bottom: 10.0,
                                            top: 10.0),
                                        child: Text(
                                          retunListSecondValues(3).toString(),
                                          style: MyTheme.summaryCaption,
                                          textAlign: TextAlign.center,
                                        ),
                                      )),
                                ],
                              ),
                            ));
                      case 5:
                        return Container(
                            decoration: BoxDecoration(
                                color: MyTheme.kSummaryLightShade),
                            child: IntrinsicHeight(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                      flex: 7,
                                      child: Container(
                                        margin: const EdgeInsets.only(
                                            left: 10.0,
                                            right: 10.0,
                                            bottom: 10.0,
                                            top: 10.0),
                                        child: Text(
                                          retunListFirstValues(4).toString(),
                                          style: MyTheme.summaryCaption,
                                        ),
                                      )),
                                  // Container(color: Colors.black,  width: 0.8),
                                  const VerticalDivider(
                                      thickness: 1.0, color: Colors.grey),
                                  Expanded(
                                      flex: 3,
                                      child: Container(
                                        margin: const EdgeInsets.only(
                                            left: 10.0,
                                            right: 10.0,
                                            bottom: 10.0,
                                            top: 10.0),
                                        child: Text(
                                          retunListSecondValues(4).toString(),
                                          style: MyTheme.summaryCaption,
                                          textAlign: TextAlign.center,
                                        ),
                                      )),
                                ],
                              ),
                            ));
                      case 6:
                        return Container(
                            decoration:
                                BoxDecoration(color: MyTheme.kSummaryDarkShade),
                            child: IntrinsicHeight(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                      flex: 7,
                                      child: Container(
                                        margin: const EdgeInsets.only(
                                            left: 10.0,
                                            right: 10.0,
                                            bottom: 10.0,
                                            top: 10.0),
                                        child: Text(
                                          retunListFirstValues(5).toString(),
                                          style: MyTheme.summaryCaption,
                                        ),
                                      )),
                                  // Container(color: Colors.black,  width: 0.8),
                                  const VerticalDivider(
                                      thickness: 1.0, color: Colors.grey),
                                  Expanded(
                                      flex: 3,
                                      child: Container(
                                        margin: const EdgeInsets.only(
                                            left: 10.0,
                                            right: 10.0,
                                            bottom: 10.0,
                                            top: 10.0),
                                        child: Text(
                                          retunListSecondValues(5).toString(),
                                          style: MyTheme.summaryCaption,
                                          textAlign: TextAlign.center,
                                        ),
                                      )),
                                ],
                              ),
                            ));
                      case 7:
                        return Container(
                            decoration: BoxDecoration(
                                color: MyTheme.kSummaryLightShade),
                            child: IntrinsicHeight(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                      flex: 7,
                                      child: Container(
                                        margin: const EdgeInsets.only(
                                            left: 10.0,
                                            right: 10.0,
                                            bottom: 10.0,
                                            top: 10.0),
                                        child: Text(
                                          retunListFirstValues(6).toString(),
                                          style: MyTheme.summaryCaption,
                                        ),
                                      )),
                                  // Container(color: Colors.black,  width: 0.8),
                                  const VerticalDivider(
                                      thickness: 1.0, color: Colors.grey),
                                  Expanded(
                                      flex: 3,
                                      child: Container(
                                        margin: const EdgeInsets.only(
                                            left: 10.0,
                                            right: 10.0,
                                            bottom: 10.0,
                                            top: 10.0),
                                        child: Text(
                                          retunListSecondValues(6).toString(),
                                          style: MyTheme.summaryCaption,
                                          textAlign: TextAlign.center,
                                        ),
                                      )),
                                ],
                              ),
                            ));

                      case 8:
                        return Container(
                            decoration: BoxDecoration(
                                color: MyTheme.kSummaryLightShade),
                            child: IntrinsicHeight(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                      flex: 7,
                                      child: Container(
                                        margin: const EdgeInsets.only(
                                            left: 10.0,
                                            right: 10.0,
                                            bottom: 10.0,
                                            top: 10.0),
                                        child: Text(
                                          retunListFirstValues(7).toString(),
                                          style: MyTheme.summaryCaption,
                                        ),
                                      )),
                                  // Container(color: Colors.black,  width: 0.8),
                                  const VerticalDivider(
                                      thickness: 1.0, color: Colors.grey),
                                  Expanded(
                                      flex: 3,
                                      child: Container(
                                        margin: const EdgeInsets.only(
                                            left: 10.0,
                                            right: 10.0,
                                            bottom: 10.0,
                                            top: 10.0),
                                        child: Text(
                                          retunListSecondValues(7).toString(),
                                          style: MyTheme.summaryCaption,
                                          textAlign: TextAlign.center,
                                        ),
                                      )),
                                ],
                              ),
                            ));

                      default:
                        return Container(
                            padding: const EdgeInsets.only(
                                left: 10, right: 10, bottom: 15, top: 15),
                            height: 50,
                            constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width * 0.6),
                            decoration: BoxDecoration(
                                color: MyTheme.kBlueShade,
                                border: Border.all(
                                    color: MyTheme.kBlueShade, width: 1),
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(16),
                                  topRight: Radius.circular(16),
                                  bottomLeft: Radius.circular(0),
                                  bottomRight: Radius.circular(0),
                                )),
                            child: Center(
                                child: Text('Maintainance Summary',
                                    style: MyTheme.summaryTitle.copyWith(
                                      color: MyTheme.kWhite,
                                    ))));
                    }
                  },
                  itemCount: _mapOfValuesSelection.length + 1,
                )),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: FloatingActionButton.extended(
                  backgroundColor: MyTheme.kBlueShade,
                  label: Text(
                    "Submit",
                    style:
                        MyTheme.chatSenderName.copyWith(color: MyTheme.kWhite),
                  ),
                  onPressed: () async {
                    /* showDialog(context: context, builder: (context) {

                    }, useSafeArea: true
                    );*/
                    // Future.delayed(const Duration(seconds: 12), () { //asynchronous delay
                    //    setState(() {
                    //      _visible=!_visible;
                    //    });
                    // });
                    BuildContext localcontext = context;

                    showDialog(
                        context: context,
                        builder: (context) {
                          Future.delayed(Duration(seconds: 5), () {
                            Navigator.of(context).pop(true);

                            Get.defaultDialog (
                                barrierDismissible: false,
                                title: "Acknowledgment",
                                content: const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Visibility(
                                    child: Text(
                                      "Your Maintainance Summary has been submitted successfully",
                                      style: MyTheme.chatSenderName,
                                    ),
                                    visible: true,
                                  ),
                                ),

                                contentPadding: const EdgeInsets.all(8),
                                // textCustom: "OK",
                                textCancel: "OK",
                                onCancel: () {
                                  Navigator.pushReplacement(localcontext,
                                      MaterialPageRoute(builder: (_) => Profile()));
                                });
                          });
                          return Container(
                            alignment: Alignment.center,
                            width: 60,
                            height: 60,
                            child: CircularProgressIndicator(),
                          );
                        });
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
