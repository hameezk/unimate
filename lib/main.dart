import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unimate/models/firebase_helper.dart';
import 'package:unimate/pages/home_page.dart';
import 'package:unimate/pages/login_page.dart';
import 'package:unimate/providers/theme_provider.dart';
import 'package:uuid/uuid.dart';
import 'models/user_model.dart';

var uuid = const Uuid();

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // to ensure initialized WidgetsFlutterBinding

  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'AIzaSyDP0wdaPJSoziyA9ZLe2saHMxaJizxxbjA',
        appId: "1:730733691918:web:2de2171afe7b6ef45ca85f",
        messagingSenderId: '730733691918',
        projectId: 'unimate-63438',
        authDomain: "unimate-63438.firebaseapp.com",
        storageBucket: "unimate-63438.appspot.com",
      ),
    );
  } else {
    await Firebase.initializeApp();
  } // to wait for firebase to initialize the app from console.firebase.google.com

  User? currentUser = FirebaseAuth.instance
      .currentUser; // to store info about logged in user (if any) i.e. email/password

  if (currentUser != null) {
    UserModel? thisUserModel =
        await FirebaseHelper.getUserModelById(currentUser.uid);
    if (thisUserModel != null) {
      runApp(
          MyAppLoggedIn(userModel: thisUserModel, firebaseUser: currentUser));
    }
  } else {
    runApp(const MyApp());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (context) => ThemeProvider(),
        builder: (context, _) {
          final themeProvider = Provider.of<ThemeProvider>(context);

          return MaterialApp(
            debugShowCheckedModeBanner: false,
            themeMode: themeProvider.themeMode,
            theme: MyThemes.lightTheme,
            darkTheme: MyThemes.darkTheme,
            home: const LoginPage(),
          );
        },
      );
}

class MyAppLoggedIn extends StatelessWidget {
  final UserModel userModel;
  final User firebaseUser;

  const MyAppLoggedIn(
      {Key? key, required this.userModel, required this.firebaseUser})
      : super(key: key);

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (context) => ThemeProvider(),
        builder: (context, _) {
          final themeProvider = Provider.of<ThemeProvider>(context);

          return MaterialApp(
            debugShowCheckedModeBanner: false,
            themeMode: themeProvider.themeMode,
            theme: MyThemes.lightTheme,
            darkTheme: MyThemes.darkTheme,
            home: HomePage(
              userModel: userModel,
              firebaseUser: firebaseUser,
            ),
          );
        },
      );
}
