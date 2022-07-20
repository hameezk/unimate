import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:unimate/models/user_model.dart';
import 'package:unimate/pages/user_profile.dart';

class EditProfile extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;

  const EditProfile(
      {Key? key, required this.userModel, required this.firebaseUser})
      : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  var temp = 0;
  List<String> roles = ["Admin", "Instructor", "Student"];
  List<String> departments = [
    "Administration",
    "Computing & Technology",
    "Buisness Administration",
    "Fashion & Design",
    "Media Studies",
  ];
  File? imageFile;
  String? role = "";
  String? department = "";
  TextEditingController fullNameController = TextEditingController();
  TextEditingController roleController = TextEditingController();
  TextEditingController idDesgController = TextEditingController();

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

    if (fullName.isEmpty ||
        imageFile == override ||
        role == "" ||
        department == "") {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(context).canvasColor,
          duration: const Duration(seconds: 1),
          content: const Text("Please fill all the fields!"),
        ),
      );
    } else {
      uploadData();
    }
  }

  void uploadData() async {
    if (temp == 1) {
      UploadTask uploadTask = FirebaseStorage.instance
          .ref("profilepictures")
          .child(widget.userModel.uid.toString())
          .putFile(imageFile!);
      TaskSnapshot snapshot = await uploadTask;
      String imageUrl = await snapshot.ref.getDownloadURL();
      widget.userModel.profilePic = imageUrl;
    }

    String fullname = fullNameController.text.trim();
    widget.userModel.fullName = fullname;

    widget.userModel.role = role;
    widget.userModel.department = department;

    await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.userModel.uid)
        .set(widget.userModel.toMap())
        .then(
      (value) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Theme.of(context).canvasColor,
            duration: const Duration(seconds: 1),
            content: const Text("Profile Updated"),
          ),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) {
              return UserProfile(
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
    (role == "") ? role = widget.userModel.role : null;
    (department == "") ? department = widget.userModel.department : null;
    fullNameController.text = widget.userModel.fullName.toString();
    idDesgController.text = widget.userModel.idDesg.toString();
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).canvasColor,
        centerTitle: true,
        title: const Text(
          "Edit Profile",
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            CupertinoButton(
              onPressed: () {
                temp = 1;
                showImageOptions();
              },
              child: CircleAvatar(
                backgroundColor: Theme.of(context).canvasColor,
                foregroundColor: Colors.white,
                radius: 60,
                backgroundImage:
                    (imageFile != null) ? FileImage(imageFile!) : null,
                foregroundImage: (imageFile == null)
                    ? NetworkImage(widget.userModel.profilePic!)
                    : null,
              ),
            ),
            (widget.userModel.role == "Admin")
                ? Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40.0, vertical: 20),
                    child: Column(
                      children: [
                        TextField(
                          controller: fullNameController,
                          decoration: const InputDecoration(
                              labelText: "Full name:",
                              hintText: "Enter full name"),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        (widget.userModel.role == "Student")
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
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                isExpanded: true,
                                hint: const Text("Select Department"),
                                value: department,
                                items:
                                    departments.map(buildMenuDept).toList(),
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
                        Center(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                isExpanded: true,
                                hint: const Text("Select Role"),
                                value: role,
                                items: roles.map(buildMenuItem).toList(),
                                onChanged: (value) => setState(
                                  () {
                                    role = value;
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : Container(),
            const SizedBox(
              height: 30,
            ),
            CupertinoButton(
              color: Theme.of(context).canvasColor,
              onPressed: () {
                checkValues();
              },
              child: const Text(
                "Submit",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      );

  DropdownMenuItem<String> buildMenuDept(String item) => DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      );
}
