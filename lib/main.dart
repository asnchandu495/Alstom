import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qandaapp/chatscreen/q_a_room.dart';
import 'package:qandaapp/models/user_model.dart';
import 'package:qandaapp/splash/splash_screen.dart';

import 'app_theme.dart';
import 'chat_room.dart';

/**
 *  Date add in conversation

    |

    Send button need to complete

    |

    Bottomsheet with chips
 *
 */

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(
        const MyApp()); /*)*/
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Q&A PoC',
      theme: ThemeData(
        // primaryColor: MyTheme.kPrimaryColor,
        // accentColor: MyTheme.kAccentColor,
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme
              .of(context)
              .textTheme,
        ),
        primarySwatch: MyTheme.createMaterialColor(
            MyTheme.kPrimaryColorVariant),
        visualDensity: VisualDensity.standard,
      ),
      home: SplashScreen(),
    );
  }
}
