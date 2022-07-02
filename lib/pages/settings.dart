import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:unimate/widgets/navbar.dart';

import '../models/user_model.dart';
import '../widgets/change_theme_button.dart';

class Settings extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;
  const Settings(
      {Key? key, required this.userModel, required this.firebaseUser})
      : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  int selectedIndex = 4;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).canvasColor,
        title: const Text("Settings"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10),
            child: ListTile(
              title: const Text('Language'),
              subtitle: const Text('English'),
              leading: const Icon(Icons.language),
              onTap: () {},
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text('Dark Theme'),
                ChangeThemeButtonWidget(),
              ],
            ),
          )
        ],
      ),
      bottomNavigationBar: NavBar(
          userModel: widget.userModel,
          firebaseUser: widget.firebaseUser,
          selectedPage: selectedIndex),
    );
  }
}
