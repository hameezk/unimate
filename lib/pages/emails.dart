import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:unimate/models/email_model.dart';
import 'package:unimate/models/user_model.dart';
import 'package:unimate/pages/create_email.dart';
import 'package:unimate/pages/email_details.dart';

class Emails extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;

  const Emails({Key? key, required this.userModel, required this.firebaseUser})
      : super(key: key);

  @override
  State<Emails> createState() => _EmailsState();
}

class _EmailsState extends State<Emails> with TickerProviderStateMixin {
  int filterSubject = -1;
  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          bottom: const TabBar(
            indicatorColor: Colors.white54,
            tabs: [
              Tab(
                  child: Text(
                'Received',
                style: TextStyle(color: Colors.white54),
              )),
              Tab(
                  child: Text(
                'Sent',
                style: TextStyle(color: Colors.white54),
              )),
            ],
          ),
          backgroundColor: Theme.of(context).canvasColor,
          title: const Text("Email"),
          actions: [
            SizedBox(
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                    isExpanded: false,
                    icon: const Icon(
                      Icons.align_horizontal_left,
                      color: Colors.white,
                    ),
                    // value: role,
                    items: EmailModel.subjects.map(buildMenuItem).toList(),
                    onChanged: (value) {
                      if (value == 'Remove Filter') {
                        setState(
                          () {
                            filterSubject = -1;
                          },
                        );
                      } else {
                        setState(
                          () {
                            filterSubject = EmailModel.subjects.indexOf(value!);
                          },
                        );
                      }
                    }),
              ),
            ),
            const SizedBox(
              width: 10,
            )
          ],
        ),
        body: TabBarView(
          children: [
            showReceivedEmails(),
            showSentEmails(),
          ],
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(20.0),
          child: FloatingActionButton(
            backgroundColor: Theme.of(context).canvasColor,
            child: const Icon(
              Icons.add,
              color: Colors.white54,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return CreateEmail(
                    userModel: widget.userModel,
                    firebaseUser: widget.firebaseUser,
                    isReply: false,
                  );
                }),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget showReceivedEmails() {
    return StreamBuilder(
      stream: (filterSubject >= 0)
          ? FirebaseFirestore.instance
              .collection("email")
              .where("recipant", isEqualTo: widget.userModel.uid)
              .where('subject', isEqualTo: filterSubject)
              .snapshots()
          : FirebaseFirestore.instance
              .collection("email")
              .where("recipant", isEqualTo: widget.userModel.uid)
              .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData) {
            QuerySnapshot dataSnapshot = snapshot.data as QuerySnapshot;
            if (dataSnapshot.docs.isNotEmpty) {
              return ListView.builder(
                  shrinkWrap: true,
                  itemCount: dataSnapshot.docs.length,
                  itemBuilder: (context, index) {
                    Map<String, dynamic> userMap =
                        dataSnapshot.docs[index].data() as Map<String, dynamic>;

                    EmailModel emailModel = EmailModel.fromMap(userMap);

                    return Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: GestureDetector(
                        onTap: () => (widget.userModel.role != 'Student')
                            ? Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) {
                                  return EmailDetails(
                                    userModel: widget.userModel,
                                    firebaseUser: widget.firebaseUser,
                                    emailModel: emailModel,
                                  );
                                }),
                              )
                            : null,
                        child: Card(
                          child: SizedBox(
                            width: double.infinity,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  (emailModel.subject == 3)
                                      ? Text(
                                          emailModel.otherSubject!,
                                          style: TextStyle(
                                            color:
                                                Theme.of(context).canvasColor,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 20,
                                          ),
                                        )
                                      : Text(
                                          EmailModel
                                              .subjects[emailModel.subject!],
                                          style: TextStyle(
                                            color:
                                                Theme.of(context).canvasColor,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 20,
                                          ),
                                        ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    emailModel.text ?? '',
                                    textAlign: TextAlign.justify,
                                    maxLines: 10,
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        DateFormat("h:mm a · MMM d, yyyy")
                                            .format(
                                                emailModel.createdon!.toDate()),
                                        style: TextStyle(
                                          color:
                                              Theme.of(context).indicatorColor,
                                          fontSize: 12,
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
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
            return const Text(
              "An error occoured!",
              style: TextStyle(
                color: Colors.blueGrey,
              ),
            );
          } else {
            return const Text(
              "No results found!",
              style: TextStyle(
                color: Colors.blueGrey,
              ),
            );
          }
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget showSentEmails() {
    return StreamBuilder(
      stream: (filterSubject >= 0)
          ? FirebaseFirestore.instance
              .collection("email")
              .where("sender", isEqualTo: widget.userModel.uid)
              .where('subject', isEqualTo: filterSubject)
              .snapshots()
          : FirebaseFirestore.instance
              .collection("email")
              .where("sender", isEqualTo: widget.userModel.uid)
              .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData) {
            QuerySnapshot dataSnapshot = snapshot.data as QuerySnapshot;
            if (dataSnapshot.docs.isNotEmpty) {
              return ListView.builder(
                  shrinkWrap: true,
                  itemCount: dataSnapshot.docs.length,
                  itemBuilder: (context, index) {
                    Map<String, dynamic> userMap =
                        dataSnapshot.docs[index].data() as Map<String, dynamic>;

                    EmailModel emailModel = EmailModel.fromMap(userMap);

                    return Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Card(
                        child: SizedBox(
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                (emailModel.subject == 3)
                                    ? Text(
                                        emailModel.otherSubject!,
                                        style: TextStyle(
                                          color: Theme.of(context).canvasColor,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 20,
                                        ),
                                      )
                                    : Text(
                                        EmailModel
                                            .subjects[emailModel.subject!],
                                        style: TextStyle(
                                          color: Theme.of(context).canvasColor,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 20,
                                        ),
                                      ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  emailModel.text ?? '',
                                  textAlign: TextAlign.justify,
                                  maxLines: 10,
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      DateFormat("h:mm a · MMM d, yyyy").format(
                                          emailModel.createdon!.toDate()),
                                      style: const TextStyle(
                                        color: Colors.black38,
                                        fontSize: 12,
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
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
            return const Text(
              "An error occoured!",
              style: TextStyle(
                color: Colors.blueGrey,
              ),
            );
          } else {
            return const Text(
              "No results found!",
              style: TextStyle(
                color: Colors.blueGrey,
              ),
            );
          }
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
