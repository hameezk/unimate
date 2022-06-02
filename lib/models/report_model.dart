class ReportModel {
  String? reportId;
  String? reportedUserId;
  String? currentUserId;
  String? chatroomId;
  int? reasonIndex;
  List? reportReasons;
  String? reportText;

  ReportModel({
    this.reportId,
    this.reportedUserId,
    this.currentUserId,
    this.chatroomId,
    this.reasonIndex,
    this.reportReasons,
    this.reportText,
  });

  ReportModel.fromMap(Map<String, dynamic> map) {
    reportId = map["reportId"];
    reportedUserId = map["reportedUserId"];
    currentUserId = map["currentUserId"];
    chatroomId = map["chatroomId"];
    reasonIndex = map["reasonIndex"];
    reportReasons = map["reportReasons"];
    reportText = map["reportText"];
  }

  Map<String, dynamic> toMap() {
    return {
      "reportId": reportId,
      "reportedUserId": reportedUserId,
      "currentUserId": currentUserId,
      "chatroomId": chatroomId,
      "reasonIndex": reasonIndex,
      "reportReasons": reportReasons,
      "reportText": reportText,
    };
  }
}
