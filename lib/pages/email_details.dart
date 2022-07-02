import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:unimate/models/email_model.dart';
import 'package:unimate/models/firebase_helper.dart';
import 'package:unimate/models/user_model.dart';
import 'package:unimate/pages/create_email.dart';

class EmailDetails extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;
  final EmailModel emailModel;

  const EmailDetails(
      {Key? key,
      required this.userModel,
      required this.firebaseUser,
      required this.emailModel})
      : super(key: key);

  @override
  State<EmailDetails> createState() => _EmailDetailsState();
}

class _EmailDetailsState extends State<EmailDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).canvasColor,
        title: const Text("Email Details"),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: FirebaseHelper.getUserModelById(widget.emailModel.sender!),
          builder: (context, snap) {
            if (snap.connectionState == ConnectionState.done) {
              UserModel? sender = snap.data as UserModel?;
              return Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 15),
                      child: RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: (widget.emailModel.isReply!) ? 'RE: ' : '',
                              style: TextStyle(
                                color: Theme.of(context).indicatorColor,
                                fontSize: 28,
                              ),
                            ),
                            TextSpan(
                              text: (widget.emailModel.subject == 3)
                                  ? widget.emailModel.otherSubject!
                                  : EmailModel
                                      .subjects[widget.emailModel.subject!],
                              style: TextStyle(
                                color: Theme.of(context).indicatorColor,
                                fontSize: 28,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image.network(
                          sender!.profilePic!,
                          fit: BoxFit.contain,
                        ),
                      ),
                      title: Text(
                        sender.fullName!,
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      subtitle: Text(
                        DateFormat("h:mm a · MMM d, yyyy")
                            .format(widget.emailModel.createdon!.toDate()),
                        style: TextStyle(
                          color: Theme.of(context).indicatorColor,
                          fontSize: 14,
                        ),
                      ),
                      trailing: IconButton(
                          onPressed: () {
                            _reply(sender.email!);
                          },
                          icon: const Icon(Icons.reply)),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 15),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                            // border: Border.all(
                            //   color: Colors.black54,
                            // ),
                            borderRadius: BorderRadius.circular(20)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            widget.emailModel.text!,
                            textAlign: TextAlign.justify,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 19,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }

  void _reply(String id) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        return CreateEmail(
          userModel: widget.userModel,
          firebaseUser: widget.firebaseUser,
          isReply: true,
          parentEmail: widget.emailModel,
          parentEmailId: id,
        );
      }),
    );
  }
}
