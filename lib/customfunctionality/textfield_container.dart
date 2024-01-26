import 'package:flutter/material.dart';

import 'package:qandaapp/app_theme.dart';

class TextFieldContainer extends StatelessWidget {
  final Widget child;
  const TextFieldContainer({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
      width: size.width * 0.8,
      height: 40,
      decoration: BoxDecoration(
        color: MyTheme.kWhite,
        border: Border.all(width: 1,color: MyTheme.kBorderUser),
        borderRadius: BorderRadius.circular(0),
      ),
      child: child,
    );
  }
}