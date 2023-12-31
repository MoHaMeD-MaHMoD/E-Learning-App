import 'package:dr_mohamed_app/constants/icons.dart';
import 'package:dr_mohamed_app/firebase%20services/fire_store.dart';
import 'package:dr_mohamed_app/models/lesson.dart';
import 'package:dr_mohamed_app/screens/video_shower.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LessonCard extends StatelessWidget {
  final Lesson lesson;
  const LessonCard({super.key, required this.lesson, required int itemCount});

  @override
  Widget build(BuildContext context) {
    showmodel() {
      return showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            children: [
              SimpleDialogOption(
                onPressed: () async {
                  FirestoreMethods().deleteLesson(
                      collec: '${lesson.sybjectType}${lesson.classNumber}',
                      context: context,
                      docss: '${lesson.lessonId}');
                  Navigator.of(context).pop();
                },
                padding: const EdgeInsets.all(20),
                child: const Text(
                  "are you sure ✋",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
              SimpleDialogOption(
                onPressed: () async {
                  Navigator.of(context).pop();
                },
                padding: const EdgeInsets.all(20),
                child: const Text(
                  "Cancel",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          );
        },
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      child: Row(
        children: [
          FirebaseAuth.instance.currentUser!.email ==
                  'abdelhameedmuhammad2@gmail.com'
              ? IconButton(
                  iconSize: 32,
                  onPressed: () {
                    showmodel();
                  },
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  ))
              : const Text(''),
          const SizedBox(
            width: 15,
          ),
          InkWell(
            onTap: () async {
              FirestoreMethods().addToWatchingList(
                  classNumber: lesson.classNumber,
                  lessonId: lesson.lessonId,
                  sybjectType: lesson.sybjectType);

              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => VideoShow(
                          url: lesson.url,
                        )),
              );
            },
            child: Image.asset(
              icPlayNext,
              height: 45,
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  lesson.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  lesson.duration,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          lesson.wishlist.contains(FirebaseAuth.instance.currentUser!.uid)
              ? InkWell(
                  onTap: () async {
                    FirestoreMethods().removeFromWishList(
                        classNumber: lesson.classNumber,
                        lessonId: lesson.lessonId,
                        lessonName: lesson.sybjectType);
                  },
                  child: Image.asset(
                    icWishlist,
                    height: 30,
                  ),
                )
              : InkWell(
                  onTap: () async {
                    FirestoreMethods().addToWishList(
                        classNumber: lesson.classNumber,
                        lessonId: lesson.lessonId,
                        sybjectType: lesson.sybjectType);
                  },
                  child: Image.asset(
                    icWishlistOutlined,
                    height: 30,
                  ),
                ),
          const SizedBox(
            width: 8,
          ),
          lesson.watchingList.contains(FirebaseAuth.instance.currentUser!.uid)
              ? Image.asset(
                  icDone,
                  height: 30,
                )
              : Image.asset(
                  icLock,
                  height: 30,
                ),
        ],
      ),
    );
  }
}
