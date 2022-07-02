import 'package:cloud_firestore/cloud_firestore.dart';

class EmailModel {
  String? emailId;
  String? sender;
  String? recipant;
  String? text;
  String? otherSubject;
  int? subject;
  bool? seen;
  Timestamp? createdon;
  bool? isReply;
  String? parentId;

  EmailModel({
    this.emailId,
    this.sender,
    this.recipant,
    this.text,
    this.seen,
    this.otherSubject,
    this.createdon,
    this.subject,
    this.isReply,
    this.parentId,
  });

  EmailModel.fromMap(Map<String, dynamic> map) {
    emailId = map["emailId"];
    sender = map["sender"];
    text = map["text"];
    seen = map["seen"];
    createdon = map["createdOn"];
    subject = map["subject"];
    recipant = map["recipant"];
    otherSubject = map["otherSubject"];
    isReply = map["isReply"];
    parentId = map["parentId"];
  }

  Map<String, dynamic> toMap() {
    return {
      "emailId": emailId,
      "sender": sender,
      "text": text,
      "seen": seen,
      "createdOn": createdon,
      "subject": subject,
      "recipant": recipant,
      "otherSubject": otherSubject,
      "isReply": isReply,
      "parentId": parentId,
    };
  }

  static final List<String> subjects = [
    'Attendance',
    'Marks Distribution',
    'Inquiry',
    'Other',
    'demo'
  ];
}
