
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';


import '../app_theme.dart';

class StringValueSelector extends StatelessWidget {
  final buttonPadding = const EdgeInsets.fromLTRB(0, 0, 0, 0);

  // final List<int> data;
  final Map<String, int> data;
  final String label;
  final Function(String) onSelectedValue;
  final initialValue;

  final _currentHorizontalIntValue = 0.obs;

  StringValueSelector(
      {Key? key,
      required this.data,
      required this.initialValue,
      required this.label,
      required this.onSelectedValue})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    _currentHorizontalIntValue.value = data[initialValue]!;
    return Container(
      decoration: _getShadowDecoration(),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          /*Expanded(
              child: */
          // Padding(
          //     child: Obx(() => NumberPicker(
          //           value: _currentHorizontalIntValue.value,
          //           minValue: data.values.elementAt(0),
          //           maxValue: data.values.elementAt(data.length - 1),
          //           step: 1,
          //           itemWidth: 100,
          //           itemHeight: 40,
          //           textMapper: (s) {
          //             return data.keys.elementAt(
          //                 data.values.toList().indexOf(int.parse(s)));
          //           },
          //           axis: Axis.vertical,
          //           onChanged: (value) {
          //             _currentHorizontalIntValue.value = value;
          //
          //             onSelectedValue.call(data.keys.elementAt(value - 1));
          //           },
          //           decoration: BoxDecoration(
          //             borderRadius: BorderRadius.circular(8),
          //             color: MyTheme.kBgColor.withOpacity(0.2),
          //             border: Border.all(color: Colors.black26),
          //           ),
          //         )),
          //     padding: const EdgeInsets.only(left: 12)),
          const SizedBox(
            width: 5,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: _getDropdownIcon(),
          )
        ],
      ),
    );
  }

  BoxDecoration _getShadowDecoration() {
    return BoxDecoration(
      boxShadow: <BoxShadow>[
        BoxShadow(
          color: Colors.white.withOpacity(0.06),
          spreadRadius: 4,
          offset: const Offset(0.0, 0.0),
          blurRadius: 15.0,
        ),
      ],
    );
  }

  Widget _getDropdownIcon() {
    return Column(
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
            color: MyTheme.kRedish,
            height: 24,
            width: 24,
            child: IconButton(
              focusColor: MyTheme.kRedish,
              alignment: Alignment.center,
              color: MyTheme.kRedish,
              padding: EdgeInsets.zero,
              onPressed: () {
                if ((_currentHorizontalIntValue.value - 1) > 0) {
                  _currentHorizontalIntValue.value =
                      _currentHorizontalIntValue.value - 1;
                  onSelectedValue.call(data.keys
                      .elementAt(_currentHorizontalIntValue.value - 1));
                }
              },
              icon: Icon(
                Icons.keyboard_arrow_up_sharp,
                size: 24,
                color: MyTheme.kWhite,
              ),
            )),
        const SizedBox(
          height: 10,
        ),
        Container(
            color: MyTheme.kRedish,
            height: 24,
            width: 24,
            child: IconButton(
              alignment: Alignment.center,
              padding: EdgeInsets.zero,
              onPressed: () {
                if (_currentHorizontalIntValue.value != (data.length)) {
                  _currentHorizontalIntValue.value =
                      _currentHorizontalIntValue.value + 1;
                  onSelectedValue.call(data.keys
                      .elementAt(_currentHorizontalIntValue.value - 1));
                }
              },
              icon: Icon(
                Icons.keyboard_arrow_down_sharp,
                size: 24,
                color: MyTheme.kWhite,
              ),
            ))
      ],
    );
    /*return const Icon(
      Icons.unfold_more,
      color: Colors.blueAccent,
    );*/
  }
}

class NumberValueSelector extends StatelessWidget {
  final buttonPadding = const EdgeInsets.fromLTRB(0, 0, 0, 0);

  final List<int> data;

  // final Map<String, int> data;
  final String label;
  final Function(String) onSelectedValue;
  final int initialValue;
  final _currentHorizontalIntValue = 0.obs;
  bool isStaticValue = false;

  NumberValueSelector(
      {Key? key,
      required this.data,
      required this.initialValue,
      required this.label,
      required this.onSelectedValue,
      this.isStaticValue = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    _currentHorizontalIntValue.value = initialValue;
    var minValue = data[0];
    var maxValue = data[data.length - 1];
    return Container(
      decoration: _getShadowDecoration(),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          /*Padding(
              child: *//* isStaticValue
                  ? NumberPicker(
                      value: _currentHorizontalIntValue.value,
                      itemWidth: 100,
                      itemHeight: 40,
                      minValue: minValue,
                      maxValue: maxValue,
                      step: 1,
                      axis: Axis.vertical,
                      onChanged: (value) {
                        _currentHorizontalIntValue.value = value;
                        onSelectedValue.call(value.toString());
                      },
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: MyTheme.kBgColor.withOpacity(0.2),
                        border: Border.all(color: Colors.black26),
                      ),
                    )
                  : *//*
                  Obx(() {
                var currentValue = _currentHorizontalIntValue.value;

                // print("----CURRENT VALUE = $currentValue");
                // print("----Min VALUE = $minValue");
                // print("----Max VALUE = $maxValue");
                return NumberPicker(
                  value: currentValue,
                  itemWidth: 100,
                  itemHeight: 40,
                  minValue: isStaticValue ? minValue : data[0],
                  maxValue: isStaticValue ? maxValue : data[data.length - 1],
                  step: 1,
                  axis: Axis.vertical,
                  onChanged: (value) {
                    print(
                        "----ORIGINAL VALUE = ${_currentHorizontalIntValue.value}");
                    print("----SELECTED VALUE = $value");
                    _currentHorizontalIntValue.value = value;
                    onSelectedValue.call(value.toString());
                  },
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: MyTheme.kBgColor.withOpacity(0.2),
                    border: Border.all(color: Colors.black26),
                  ),
                );
              }),
              padding: const EdgeInsets.only(left: 12)),*/
          const SizedBox(
            width: 5,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: _getDropdownIcon(),
          )
        ],
      ),
    );
  }

  BoxDecoration _getShadowDecoration() {
    return BoxDecoration(
      boxShadow: <BoxShadow>[
        BoxShadow(
          color: Colors.white.withOpacity(0.06),
          spreadRadius: 4,
          offset: const Offset(0.0, 0.0),
          blurRadius: 15.0,
        ),
      ],
    );
  }

  Widget _getDropdownIcon() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
            color: MyTheme.kRedish,
            height: 24,
            width: 24,
            child: IconButton(
              alignment: Alignment.center,
              padding: EdgeInsets.zero,
              focusColor: MyTheme.kRedish,
              onPressed: () {
                if (_currentHorizontalIntValue.value != (data.length)) {
                  _currentHorizontalIntValue.value =
                      _currentHorizontalIntValue.value + 1;
                }
              },
              icon: Icon(
                Icons.add,
                color: MyTheme.kWhite,
              ),
            )),
        const SizedBox(
          height: 10,
        ),
        Container(
            color: MyTheme.kRedish,
            height: 24,
            width: 24,
            child: IconButton(
              alignment: Alignment.center,
              padding: EdgeInsets.zero,
              onPressed: () {
                if ((_currentHorizontalIntValue.value - 1) > 0) {
                  _currentHorizontalIntValue.value =
                      _currentHorizontalIntValue.value - 1;
                }
              },
              icon: Icon(
                Icons.remove,
                color: MyTheme.kWhite,
              ),
            ))
      ],
    );
    /*return const Icon(
      Icons.unfold_more,
      color: Colors.blueAccent,
    );*/
  }
}
