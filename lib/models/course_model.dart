class CourseModel {
  String? courseId;
  String? courseVenue;
  String? courseTitle;
  String? courseTime;
  String? courseDay;

  CourseModel({
    this.courseTitle,
    this.courseId,
    this.courseVenue,
    this.courseTime,
    this.courseDay,
  });

  CourseModel.fromMap(Map<String, dynamic> map) {
    courseId = map["courseId"];
    courseVenue = map["courseVenue"];
    courseTitle = map["courseTitle"];
    courseTime = map["courseTime"];
    courseDay = map["courseDay"];
  }

  Map<String, dynamic> toMap() {
    return {
      "courseId": courseId,
      "courseVenue": courseVenue,
      "courseTitle": courseTitle,
      "courseTime": courseTime,
      "courseDay": courseDay,
    };
  }

  static List assignedCcourses = [];
}
