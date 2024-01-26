import 'package:flutter/material.dart';
import 'package:qandaapp/app_theme.dart';
import 'package:qandaapp/customfunctionality/textfield_container.dart';

class RoundedInputField extends StatelessWidget {
  final String? hintText;
  final IconData? icon;
  final ValueChanged<String> onChanged;
  TextInputType? inputType = TextInputType.text;

  RoundedInputField({
    Key? key,
    this.hintText,
    this.icon = Icons.person,
    required this.onChanged,
    this.inputType
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            hintText!,
            style: MyTheme.chatConversation.copyWith(color: MyTheme.kBlueShade),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: TextFieldContainer(

            child: Center(
              child: TextField(
                onChanged: onChanged,
                textAlignVertical: TextAlignVertical.center,
                keyboardType: inputType,
                cursorColor: MyTheme.kPrimaryColorVariant,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
