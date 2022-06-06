import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:unimate/models/user_model.dart';

class Emails extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;

  const Emails(
      {Key? key, required this.userModel, required this.firebaseUser})
      : super(key: key);

  @override
  State<Emails> createState() => _EmailsState();
}

class _EmailsState extends State<Emails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[50],
      appBar: AppBar(
        backgroundColor: Colors.indigo[300],
        title: const Text("Email"),
      ),
    );
  }
}
