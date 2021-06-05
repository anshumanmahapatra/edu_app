import 'package:adhyapak/AuthScreens/start.dart';
import 'package:adhyapak/Helpers/answer_options.dart';
import 'package:adhyapak/Helpers/helping_widgets.dart';
import 'package:adhyapak/Helpers/essentials.dart';
import 'package:adhyapak/Helpers/upvote_downvote.dart';
import 'package:adhyapak/Home/home_screen.dart';
import 'package:adhyapak/Services/database.dart';
import 'package:adhyapak/Services/utils.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'AuthScreens/sign_in_screen.dart';
import 'AuthScreens/sign_up_screen.dart';
import 'Services/auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        debugShowCheckedModeBanner: false,
        home: HomeScreen(),
        routes: <String, WidgetBuilder>{
          "signIn": (BuildContext context) => SignInScreen(),
          "signUp": (BuildContext context) => SignUpScreen(),
          "start": (BuildContext context) => Start(),
        },
      ),
      providers: [
        ChangeNotifierProvider(create: (_) => Authentication()),
        ChangeNotifierProvider(create: (_) => DatabaseMethods()),
        ChangeNotifierProvider(create: (_) => HelpingWidgets()),
        ChangeNotifierProvider(create: (_) => Utils()),
        ChangeNotifierProvider(create: (_) => UpVotesDownVotes()),
        ChangeNotifierProvider(create: (_) => Essentials()),
        ChangeNotifierProvider(create: (_) => AnswerOptions()),
      ],
    );
  }
}
