import 'package:cloud_firestore/cloud_firestore.dart';

class EmailModel {
  String? emailId;
  String? sender;
  String? recipant;
  String? text;
  int? subject;
  bool? seen;
  Timestamp? createdon;

  EmailModel({
    this.emailId,
    this.sender,
    this.recipant,
    this.text,
    this.seen,
    this.createdon,
    this.subject,
  });

  EmailModel.fromMap(Map<String, dynamic> map) {
    emailId = map["emailId"];
    sender = map["sender"];
    text = map["text"];
    seen = map["seen"];
    createdon = map["createdOn"];
    subject = map["subject"];
    recipant = map["recipant"];
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
    };
  }

  static List<String> subjects = [
    'Attendance',
    'Marks Distribution',
    'Inquiry',
    'Other'
  ];
}
