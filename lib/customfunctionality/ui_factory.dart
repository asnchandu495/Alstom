import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:group_button/group_button.dart';
import 'package:qandaapp/models/custom_payload.dart';

import '../app_theme.dart';
import 'generate_chip.dart';

const String typeDWMPicker = 'dwmPicker';
const String typeToggle = 'toggle';
const String typeDropDown = 'dropdown';
const String typeText = 'text';
const String typeHeightPicker = "heightPicker";

Widget getSubtitleWidget(String valueToDisplay) {
  return Align(
      alignment: Alignment.topLeft,
      child: Text(
        valueToDisplay,
        textAlign: TextAlign.center,
        maxLines: 2,
        overflow: TextOverflow.visible,
        style: MyTheme.chatConversation,
      ));
}

Widget getToggleWidget(
    String title,
    RxList<bool> isSelected,
    Options options,
    int mainIndex,
    Function(int index, String value) callback,
    GroupButtonController groupButtonController) {
  String valueForOption = '';
  return LayoutBuilder(builder: (context, constraints) {
    return GroupButton(
      controller: groupButtonController,
      isRadio: true,
      options: GroupButtonOptions(
        selectedShadow: const [],
        selectedTextStyle:
            MyTheme.chatConversation.copyWith(color: MyTheme.kWhite),
        selectedColor: MyTheme.kRedish,
        unselectedShadow: const [],
        unselectedColor: MyTheme.kWhite,
        unselectedTextStyle:
            MyTheme.chatConversation.copyWith(color: MyTheme.kBlueShade),
        selectedBorderColor: Colors.pink[900],
        unselectedBorderColor: MyTheme.kDarkGrey,
        borderRadius: BorderRadius.circular(10),
        spacing: 7.5,
        runSpacing: 5,
        groupingType: GroupingType.column,
        direction: Axis.vertical,
        buttonHeight: 40,
        buttonWidth: 250,
        mainGroupAlignment: MainGroupAlignment.center,
        crossGroupAlignment: CrossGroupAlignment.center,
        groupRunAlignment: GroupRunAlignment.center,
        textAlign: TextAlign.center,
        textPadding: const EdgeInsets.all(1),
        alignment: Alignment.center,
        elevation: 5,
      ),
      onSelected: (value, index, isSelectedValue) {
        print('$index button is selected');
        valueForOption = "${options.values![index]}";
        callback.call(mainIndex, valueForOption);
        for (int buttonIndex = 0;
            buttonIndex < isSelected.length;
            buttonIndex++) {
          if (buttonIndex == index) {
            isSelected[index] = !isSelected[buttonIndex];
          } else {
            isSelected[index] = false;
          }
        }
      },
      buttons: options.values!.toList(),
      /*  constraints: BoxConstraints.expand(
              width: (constraints.maxWidth / 4) - (5 / 4), height: 25),
          borderColor: MyTheme.kDarkGrey,*/
      /*  children: options.values!.map<Widget>((s) {
            return Container(
              // margin: EdgeInsets.symmetric(horizontal: 10),
              child: getTabWidget(s, isSelected[options.values!.indexOf(s)]),
            );
          }).toList(),
          onPressed: (int index) {
            valueForOption = "${options.values![index]}";
            callback.call(mainIndex, valueForOption);
            for (int buttonIndex = 0;
                buttonIndex < isSelected.length;
                buttonIndex++) {
              if (buttonIndex == index) {
                isSelected[buttonIndex] = !isSelected[buttonIndex];
              } else {
                isSelected[buttonIndex] = false;
              }
            }
          },
          isSelected: isSelected,*/
    );
    // return Obx(() => GroupButton(
    //       isRadio: true,
    //       options: GroupButtonOptions(
    //         selectedShadow: const [],
    //         selectedTextStyle: TextStyle(
    //           fontSize: 20,
    //           color: Colors.pink[900],
    //         ),
    //         selectedColor: Colors.pink[100],
    //         unselectedShadow: const [],
    //         unselectedColor: Colors.amber[100],
    //         unselectedTextStyle: TextStyle(
    //           fontSize: 20,
    //           color: Colors.amber[900],
    //         ),
    //         selectedBorderColor: Colors.pink[900],
    //         unselectedBorderColor: Colors.amber[900],
    //         borderRadius: BorderRadius.circular(100),
    //         spacing: 10,
    //         runSpacing: 10,
    //         groupingType: GroupingType.wrap,
    //         direction: Axis.horizontal,
    //         buttonHeight: 40,
    //         buttonWidth: 100,
    //         mainGroupAlignment: MainGroupAlignment.start,
    //         crossGroupAlignment: CrossGroupAlignment.start,
    //         groupRunAlignment: GroupRunAlignment.start,
    //         textAlign: TextAlign.center,
    //         textPadding: EdgeInsets.zero,
    //         alignment: Alignment.center,
    //         elevation: 5,
    //       ),
    //       onSelected: (value, index, isSelectedValue) {
    //         print('$index button is selected');
    //         valueForOption = "${options.values![index]}";
    //         callback.call(mainIndex, valueForOption);
    //         for (int buttonIndex = 0;
    //             buttonIndex < isSelected.length;
    //             buttonIndex++) {
    //           if (buttonIndex == index) {
    //             isSelected[index] = !isSelected[buttonIndex];
    //           } else {
    //             isSelected[index] = false;
    //           }
    //         }
    //       },
    //       buttons: options.values!.toList(),
    //       /*  constraints: BoxConstraints.expand(
    //           width: (constraints.maxWidth / 4) - (5 / 4), height: 25),
    //       borderColor: MyTheme.kDarkGrey,*/
    //       /*  children: options.values!.map<Widget>((s) {
    //         return Container(
    //           // margin: EdgeInsets.symmetric(horizontal: 10),
    //           child: getTabWidget(s, isSelected[options.values!.indexOf(s)]),
    //         );
    //       }).toList(),
    //       onPressed: (int index) {
    //         valueForOption = "${options.values![index]}";
    //         callback.call(mainIndex, valueForOption);
    //         for (int buttonIndex = 0;
    //             buttonIndex < isSelected.length;
    //             buttonIndex++) {
    //           if (buttonIndex == index) {
    //             isSelected[buttonIndex] = !isSelected[buttonIndex];
    //           } else {
    //             isSelected[buttonIndex] = false;
    //           }
    //         }
    //       },
    //       isSelected: isSelected,*/
    //     ));
  });
}
