import 'package:flutter/material.dart';
import 'package:qandaapp/app_theme.dart';
import 'package:qandaapp/customfunctionality/textfield_container.dart';

class RoundedPasswordField extends StatelessWidget {
  final ValueChanged<String> onChanged;

  const RoundedPasswordField({
    Key? key,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              'Password',
              style:
                  MyTheme.chatConversation.copyWith(color: MyTheme.kBlueShade),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: TextFieldContainer(
              child: Center(
                child: TextField(
                  obscureText: true,
                  textAlignVertical: TextAlignVertical.center,
                  onChanged: onChanged,
                  cursorColor: MyTheme.kPrimaryColorVariant,
                  decoration: const InputDecoration(
                    /*suffixIcon: Icon(
                    Icons.visibility,
                    color: MyTheme.kPrimaryColorVariant,
                  ),*/
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
          )
        ]);
  }
}
