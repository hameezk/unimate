import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:unimate/models/user_model.dart';
import 'package:unimate/pages/show_department.dart';

class DepartmemntsList extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;
  const DepartmemntsList(
      {Key? key, required this.userModel, required this.firebaseUser})
      : super(key: key);

  @override
  _DepartmemntsListState createState() => _DepartmemntsListState();
}

class _DepartmemntsListState extends State<DepartmemntsList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo[300],
        title: const Text("Departments List"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return ShowDepartment(
                          userModel: widget.userModel,
                          firebaseUser: widget.firebaseUser,
                          department: "Computing & Technology",
                        );
                      },
                    ),
                  );
                },
                title: Text(
                  "Computing & Technology",
                  style: TextStyle(
                    color: Colors.indigo[300],
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return ShowDepartment(
                          userModel: widget.userModel,
                          firebaseUser: widget.firebaseUser,
                          department: "Buisness Administration",
                        );
                      },
                    ),
                  );
                },
                title: Text(
                  "Buisness Administration",
                  style: TextStyle(
                    color: Colors.indigo[300],
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return ShowDepartment(
                          userModel: widget.userModel,
                          firebaseUser: widget.firebaseUser,
                          department: "Fashion & Design",
                        );
                      },
                    ),
                  );
                },
                title: Text(
                  "Fashion & Design",
                  style: TextStyle(
                    color: Colors.indigo[300],
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return ShowDepartment(
                          userModel: widget.userModel,
                          firebaseUser: widget.firebaseUser,
                          department: "Media Studies",
                        );
                      },
                    ),
                  );
                },
                title: Text(
                  "Media Studies",
                  style: TextStyle(
                    color: Colors.indigo[300],
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
