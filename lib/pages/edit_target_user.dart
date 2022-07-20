import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:unimate/models/course_model.dart';
import 'package:unimate/models/user_model.dart';
import 'package:unimate/pages/viewer_profile.dart';

class EditTargetUser extends StatefulWidget {
  static List courses = [];
  final UserModel userModel;
  final UserModel targetUser;
  final User firebaseUser;

  const EditTargetUser(
      {Key? key,
      required this.userModel,
      required this.firebaseUser,
      required this.targetUser})
      : super(key: key);

  @override
  _EditTargetUserState createState() => _EditTargetUserState();
}

class _EditTargetUserState extends State<EditTargetUser> {
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
          .child(widget.targetUser.uid.toString())
          .putFile(imageFile!);
      TaskSnapshot snapshot = await uploadTask;
      String imageUrl = await snapshot.ref.getDownloadURL();
      widget.targetUser.profilePic = imageUrl;
    }

    String fullname = fullNameController.text.trim();
    widget.targetUser.fullName = fullname;

    widget.targetUser.role = role;
    widget.targetUser.department = department;
    widget.targetUser.courses = CourseModel.assignedCcourses;

    await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.targetUser.uid)
        .set(widget.targetUser.toMap())
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
              return ViewProfile(
                userModel: widget.userModel,
                firebaseUser: widget.firebaseUser,
                targetUserModel: widget.targetUser,
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    EditTargetUser.courses = widget.targetUser.courses ?? [];
    (role == "") ? role = widget.targetUser.role : null;
    (department == "") ? department = widget.targetUser.department : null;
    fullNameController.text = widget.targetUser.fullName.toString();
    idDesgController.text = widget.targetUser.idDesg.toString();
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
                    ? NetworkImage(widget.targetUser.profilePic!)
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
                        (widget.targetUser.role == "Student")
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
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
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
              height: 10,
            ),
            (widget.targetUser.role == 'Instructor')
                ? CupertinoButton(
                    color: Theme.of(context).canvasColor,
                    onPressed: () {
                      addCourses();
                    },
                    child: const Text(
                      "Add Courses",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  )
                : Container(
                    height: 0,
                  ),
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

  addCourses() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Courses'),
          content: StreamBuilder(
            stream:
                FirebaseFirestore.instance.collection("courses").snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.hasData) {
                  QuerySnapshot dataSnapshot = snapshot.data as QuerySnapshot;
                  if (dataSnapshot.docs.isNotEmpty) {
                    return ListView.builder(
                        shrinkWrap: true,
                        itemCount: dataSnapshot.docs.length,
                        itemBuilder: (context, index) {
                          Map<String, dynamic> courseMap =
                              dataSnapshot.docs[index].data()
                                  as Map<String, dynamic>;
                          CourseModel courseModel =
                              CourseModel.fromMap(courseMap);
                          if (dataSnapshot.docs.isNotEmpty) {
                            return CheckboxWidget(
                              courseModel: courseModel,
                            );
                          } else {
                            return Container();
                          }
                        });
                  } else {
                    return const Center(
                      child: Text(
                        "No results found!",
                        style: TextStyle(
                          color: Colors.blueGrey,
                        ),
                      ),
                    );
                  }
                } else if (snapshot.hasError) {
                  return const Center(
                    child: Text(
                      "An error occoured!",
                      style: TextStyle(
                        color: Colors.blueGrey,
                      ),
                    ),
                  );
                } else {
                  return const Center(
                    child: Text(
                      "No results found!",
                      style: TextStyle(
                        color: Colors.blueGrey,
                      ),
                    ),
                  );
                }
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                CourseModel.assignedCcourses = EditTargetUser.courses;
                print(CourseModel.assignedCcourses);
                Navigator.pop(context);
              },
              child: Text('Submit'),
            )
          ],
        );
      },
    );
  }
}

class CheckboxWidget extends StatefulWidget {
  final CourseModel courseModel;
  CheckboxWidget({Key? key, required this.courseModel}) : super(key: key);

  @override
  State<CheckboxWidget> createState() => _CheckboxWidgetState();
}

class _CheckboxWidgetState extends State<CheckboxWidget> {
  List courses = [];
  bool? _value;
  @override
  Widget build(BuildContext context) {
    _value = EditTargetUser.courses.contains(widget.courseModel.courseId);
    return CheckboxListTile(
      title: Text(widget.courseModel.courseTitle ?? ''),
      subtitle: Text(widget.courseModel.courseTime ?? ''),
      // secondary: Text(courseModel.courseVenue ?? ''),
      autofocus: false,
      selected: _value ?? false,
      value: _value,
      onChanged: (bool? value) {
        setState(() {
          _value = value;
          if (value == true) {
            EditTargetUser.courses.add(widget.courseModel.courseId);
          } else {
            if (EditTargetUser.courses.contains(widget.courseModel.courseId)) {
              EditTargetUser.courses.remove(widget.courseModel.courseId);
            }
          }
        });
      },
    );
  }
}
