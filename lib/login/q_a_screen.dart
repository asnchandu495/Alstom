import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qandaapp/chatscreen/q_a_room.dart';
import 'package:qandaapp/customfunctionality/custom_pasword_textfield.dart';
import 'package:qandaapp/customfunctionality/custom_textfield.dart';
import 'package:qandaapp/models/user_model.dart';

import '../app_theme.dart';

class QandAScreen extends StatelessWidget {
  static String routeLogin = "/LoginScreen";
  String _assetId = "", _password = "";
  final LocalKey _emailKey = ValueKey("");

  // final LocalKey _pwdKey = ValueKey("");

  QandAScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            /*const Text(
            "LOGIN",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),*/
            SizedBox(height: size.height * 0.09),
            Center(
              child: Image.asset(
                "assets/images/login.png",
                height: size.height * 0.35,
              ),
            ),
            SizedBox(height: size.height * 0.15),
            RoundedInputField(
              hintText: "Asset Id",
              onChanged: (value) {
                _assetId = value;
              },
            ),
            SizedBox(height: size.height * 0.009),
            SizedBox(
              width: size.width * 0.8,
              child: ElevatedButton(
                child: Text("Submit"),
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(MyTheme.kRedish)),
                onPressed: () {
                  if (_assetId.isEmpty) {
                    _showErrorDialog("E-mail is required");
                  } else {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (_) => QandARoom(user: botSuMed,heading: "Workorder #12345",)));
                    /*Navigator.pop(context);
                    Get.to(QandARoom(user: botSuMed),
                        transition: Transition.leftToRight);*/
                  }
                  // Get.offNamed(LoginScreen.routeLogin
                  // Get.offAll(const LoginScreen());
                },
              ),
            ),
            SizedBox(height: size.height * 0.09),
            /*    AlreadyHaveAnAccountCheck(
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return SignUpScreen();
                    },
                  ),
                );
              },
            ),*/
          ],
        ),
      ),
    );
  }

  void _showErrorDialog(String errorMessage) {
    Get.defaultDialog(
      content: Text(
        errorMessage,
        style: MyTheme.chatSenderName.copyWith(color: MyTheme.kRedish),
      ),
      title: "Error",
      textCancel: "OK",
    );
  }
}
