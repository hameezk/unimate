class AnnouncementModel {
  String? announcementId;
  String? announcementContent;
  String? announcementTitle;

  AnnouncementModel({
    this.announcementTitle,
    this.announcementId,
    this.announcementContent,
  });

  AnnouncementModel.fromMap(Map<String, dynamic> map) {
    announcementId = map["announcementId"];
    announcementContent = map["announcementContent"];
    announcementTitle = map["announcementTitle"];
  }

  Map<String, dynamic> toMap() {
    return {
      "announcementId": announcementId,
      "announcementContent": announcementContent,
      "announcementTitle": announcementTitle,
    };
  }
}
