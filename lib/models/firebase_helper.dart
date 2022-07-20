import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:unimate/models/course_model.dart';
import 'package:unimate/models/user_model.dart';

class FirebaseHelper {
  static Future<UserModel?> getUserModelById(String uid) async {
    UserModel? userModel;
    DocumentSnapshot docsnap =
        await FirebaseFirestore.instance.collection("users").doc(uid).get();

    if (docsnap.data() != null) {
      userModel = UserModel.fromMap(docsnap.data() as Map<String, dynamic>);
    }
    return userModel;
  }

  static Future<CourseModel?> getCourseModelById(String courseId) async {
    CourseModel? courseModel;
    DocumentSnapshot docsnap =
        await FirebaseFirestore.instance.collection("courses").doc(courseId).get();

    if (docsnap.data() != null) {
      courseModel = CourseModel.fromMap(docsnap.data() as Map<String, dynamic>);
    }
    return courseModel;
  }
}
