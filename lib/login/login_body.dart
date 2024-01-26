import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qandaapp/LandingScreen/LandingScreen.dart';
import 'package:qandaapp/customfunctionality/custom_pasword_textfield.dart';
import 'package:qandaapp/customfunctionality/custom_textfield.dart';
import 'package:qandaapp/login/q_a_screen.dart';

import '../app_theme.dart';

class LoginScreen extends StatelessWidget {
  static String routeLogin = "/LoginScreen";
  String _emailId = "", _password = "";
  final LocalKey _emailKey = ValueKey("");
  final LocalKey _pwdKey = ValueKey("");

  LoginScreen({
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
              hintText: "Email Id",
              onChanged: (value) {
                _emailId = value;
              },
            ),
            SizedBox(height: size.height * 0.009),
            RoundedPasswordField(
              key: _pwdKey,
              onChanged: (value) {
                _password = value;
              },
            ),
            SizedBox(height: size.height * 0.009),
            SizedBox(
                width: size.width * 0.8,
                child: const Align(
                  child: Text(
                    "Forgot Password?",
                    style: MyTheme.chatConversation,
                  ),
                  alignment: Alignment.centerRight,
                )),
            SizedBox(height: size.height * 0.009),
            SizedBox(
              width: size.width * 0.8,
              child: ElevatedButton(
                child: Text("LOGIN"),
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(MyTheme.kRedish)),
                onPressed: () {
                  /*if (_emailId.isEmpty) {
                    _showErrorDialog("E-mail is required");
                  } else if (_emailId.isNotEmpty && !_emailId.isEmail) {
                    _showErrorDialog("Invalid E-mail address");
                  } else if (_password.isEmpty) {
                    _showErrorDialog("Password is required");
                  } else if (_password.length < 8) {
                    _showErrorDialog("Password must be 8 characters long");
                  } else {*/

                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (_) => Profile()));

                  // }
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
