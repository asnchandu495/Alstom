import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qandaapp/LandingScreen/LandingScreen.dart';
import 'package:qandaapp/app_theme.dart';
import 'package:qandaapp/login/login_body.dart';
import 'package:qandaapp/login/q_a_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
   return MaterialApp(
     home: SplashScreenAnimation(),
   );
  }
}

class SplashScreenAnimation extends StatefulWidget {
  const SplashScreenAnimation({Key? key}) : super(key: key);

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreenAnimation> with SingleTickerProviderStateMixin {

  var _visible = true;

  late AnimationController animationController;
  late Animation<double> animation;

  startTime() async {
    var _duration = const Duration(seconds: 5);
    return  Timer(_duration, navigationPage);
  }

  void navigationPage() {
    //Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => QandAScreen()));
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => Profile()));
  }

  @override
  void initState() {
    super.initState();
    animationController =  AnimationController(
        vsync: this, duration:  Duration(seconds: 3));
    animation =
     CurvedAnimation(parent: animationController, curve: Curves.easeOut);

    animation.addListener(() => setState(() {}));
    animationController.forward();

    setState(() {
      _visible = !_visible;
    });
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    // Future.delayed(const Duration(seconds: 2), () {
    //   // Get.offAll(const SplashScreen());
    //   // Navigator.pop(context);
    //   Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => QandAScreen()));
    //   // Get.to( QandAScreen(), transition: Transition.circularReveal);
    // });

    /*
    return Scaffold(
      backgroundColor: MyTheme.kBgColor,
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset("assets/images/bot.png"),
                const Text(
                  "Chatbot",
                  style: MyTheme.splashScreenTitle,
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Image.asset("assets/images/sutherland_powered.png"),
          )
        ],
      ),
    );
    */
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
           Column(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(padding: EdgeInsets.only(bottom: 30.0),child:new Image.asset('assets/images/sutherland_powered.png',height: 30.0,fit: BoxFit.scaleDown,))
            ],),
           Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
               Image.asset(
                'assets/images/alstomlogo.png',
                width: animation.value * 250,
                height: animation.value * 250,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

