import 'package:flutter/material.dart';
import 'package:unimate/models/course_model.dart';
import 'package:unimate/models/firebase_helper.dart';

class OfferedCourses extends StatelessWidget {
  final List offeredCourseIds;
  const OfferedCourses({Key? key, required this.offeredCourseIds})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return (offeredCourseIds.isNotEmpty)
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: offeredCourseIds.length,
            itemBuilder: (context, index) {
              return FutureBuilder(
                  future: FirebaseHelper.getCourseModelById(
                      offeredCourseIds[index]),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      CourseModel? courseModel = snapshot.data as CourseModel?;
                      return Padding(
                        padding: EdgeInsets.all(5.0),
                        child: ListTile(
                          isThreeLine: true,
                          title: Text(courseModel!.courseTitle ?? ''),
                          subtitle: Text(
                              "${courseModel.courseDay ?? ''}\n${courseModel.courseTime ?? ''}"),
                          trailing: Text(courseModel.courseVenue ?? ''),
                        ),
                      );
                    } else {
                      return Container(
                        height: 0,
                      );
                    }
                  });
            })
        : Container(
            height: 0,
          );
  }
}
