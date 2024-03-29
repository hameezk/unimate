import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:unimate/models/user_model.dart';
import 'package:unimate/pages/home_page.dart';

class CompleteProfile extends StatefulWidget {
  final UserModel NewUserModel;
  final User NewFirebaseUser;
  final UserModel userModel;
  final User firebaseUser;

  const CompleteProfile(
      {Key? key,
      required this.NewUserModel,
      required this.NewFirebaseUser,
      required this.userModel,
      required this.firebaseUser})
      : super(key: key);

  @override
  _CompleteProfileState createState() => _CompleteProfileState();
}

class _CompleteProfileState extends State<CompleteProfile> {
  List<String> departments = [
    "Administration",
    "Computing & Technology",
    "Buisness Administration",
    "Fashion & Design",
    "Media Studies",
  ];

  String? department = "Computing & Technology";
  File? imageFile;

  TextEditingController fullNameController = TextEditingController();
  TextEditingController idDesgController = TextEditingController();

  DropdownMenuItem<String> buildMenuDept(String item) => DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      );

  void selectImage(ImageSource source) async {
    XFile? selectedImage = await ImagePicker().pickImage(source: source);
    if (selectedImage != null) {
      cropImage(selectedImage);
    }
  }

  void cropImage(XFile file) async {
    File? croppedImage = await ImageCropper.cropImage(
      sourcePath: file.path,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      compressQuality: 15,
    );
    if (croppedImage != null) {
      setState(() {
        imageFile = croppedImage;
      });
    }
  }

  void showImageOptions() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            "Upload profile picture",
            style: TextStyle(
              color: Colors.blueGrey,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                onTap: () {
                  Navigator.pop(context);
                  selectImage(ImageSource.gallery);
                },
                leading: const Icon(Icons.photo_album_rounded),
                title: const Text(
                  "Select from Gallery",
                  style: TextStyle(
                    color: Colors.blueGrey,
                  ),
                ),
              ),
              ListTile(
                onTap: () {
                  Navigator.pop(context);
                  selectImage(ImageSource.camera);
                },
                leading: const Icon(CupertinoIcons.photo_camera),
                title: const Text(
                  "Take new photo",
                  style: TextStyle(
                    color: Colors.blueGrey,
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  void checkValues() {
    String fullName = fullNameController.text.trim();
    String idDesg = idDesgController.text.trim();

    if (fullName.isEmpty || imageFile == override || idDesg.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.blueGrey,
          duration: Duration(seconds: 1),
          content: Text("Please fill all the fields!"),
        ),
      );
    } else {
      uploadData();
    }
  }

  void uploadData() async {
    UploadTask uploadTask = FirebaseStorage.instance
        .ref("profilepictures")
        .child(widget.NewUserModel.uid.toString())
        .putFile(imageFile!);

    TaskSnapshot snapshot = await uploadTask;

    String imageUrl = await snapshot.ref.getDownloadURL();
    String fullname = fullNameController.text.trim();
    String idDesg = idDesgController.text.trim();

    widget.NewUserModel.fullName = fullname;
    widget.NewUserModel.profilePic = imageUrl;
    widget.NewUserModel.idDesg = idDesg;
    widget.NewUserModel.department = department;

    await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.NewUserModel.uid)
        .set(widget.NewUserModel.toMap())
        .then(
      (value) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.blueGrey,
            duration: Duration(seconds: 1),
            content: Text("Profile Updated"),
          ),
        );
        Navigator.popUntil(context, (route) => route.isFirst);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) {
              return HomePage(
                  userModel: widget.userModel,
                  firebaseUser: widget.firebaseUser);
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).canvasColor,
        centerTitle: true,
        title: const Text(
          "Complete Profile",
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CupertinoButton(
              onPressed: () {
                showImageOptions();
              },
              child: CircleAvatar(
                backgroundColor: Colors.blueGrey[200],
                foregroundColor: Theme.of(context).canvasColor,
                radius: 60,
                backgroundImage:
                    (imageFile != null) ? FileImage(imageFile!) : null,
                child: (imageFile == null)
                    ? const Icon(
                        Icons.person,
                        size: 60,
                      )
                    : null,
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20),
              child: Column(
                children: [
                  TextField(
                    controller: fullNameController,
                    decoration: const InputDecoration(
                        labelText: "Full name:", hintText: "Enter full name"),
                  ),
                  (widget.NewUserModel.role == "Student")
                      ? TextField(
                          controller: idDesgController,
                          decoration: const InputDecoration(
                              labelText: "Student ID:",
                              hintText: "Enter student ID:"),
                        )
                      : TextField(
                          controller: idDesgController,
                          decoration: const InputDecoration(
                              labelText: "Designation:",
                              hintText: "Enter Designation:"),
                        ),
                  const SizedBox(
                    height: 30,
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          hint: const Text("Select Department"),
                          value: department,
                          items: departments.map(buildMenuDept).toList(),
                          onChanged: (value) => setState(
                            () {
                              department = value;
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
            CupertinoButton(
              onPressed: () {
                checkValues();
              },
              child: const Text(
                "Submit",
                style: TextStyle(
                  color: Colors.blueGrey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
