import 'dart:io';
import 'dart:math';
import 'package:path/path.dart' show basename;

import 'package:dr_mohamed_app/constants/color.dart';
import 'package:dr_mohamed_app/firebase%20services/fire_store.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class VideoSelector extends StatefulWidget {
  const VideoSelector({super.key});

  @override
  State<VideoSelector> createState() => _VideoSelectorState();
}

class _VideoSelectorState extends State<VideoSelector> {
  List<String> subjectItemsList = ['Physics', 'Chemistry', 'biology'];
  String? selectedSubjectItemsList = 'Physics';
  List<String> classItemsList = ['1', '2', '3'];
  String? selectedClassItemsList = '1';

  final desController = TextEditingController();
  bool isLoading = false;
  File? galleryFile;
  String? videoName;
  XFile? xfilePick;

  final picker = ImagePicker();

  @override
  void dispose() {
    desController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // display image selected from gallery
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gallery and Camera Access'),
        backgroundColor: kPrimaryColor,
        actions: const [],
      ),
      body: Builder(
        builder: (BuildContext context) {
          return Column(
            children: [
              const SizedBox(
                height: 8,
              ),
              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(kPrimaryColor)),
                child: const Text('Select video'),
                onPressed: () {
                  _showPicker(context: context);
                },
              ),
              const SizedBox(
                height: 16,
              ),
              SizedBox(
                child: galleryFile == null
                    ? const Center(child: Text('Sorry nothing selected!!'))
                    : const Center(
                        child: Text(
                        "Video Is ready to upLoad",
                        style: TextStyle(color: Colors.green),
                      )),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
                child: TextField(
                  // controller: descriptionController,
                  maxLines: 1,
                  controller: desController,
                  decoration: const InputDecoration(
                      hintText: "write a caption...", border: InputBorder.none),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                child: Row(
                  children: [
                    const Text("select Subject Type"),
                    const SizedBox(
                      width: 11,
                    ),
                    DropdownButton<String>(
                        value: selectedSubjectItemsList,
                        items: subjectItemsList
                            .map((item) => DropdownMenuItem(
                                value: item,
                                child:
                                    Text(item, style: const TextStyle(fontSize: 18))))
                            .toList(),
                        onChanged: (item) =>
                            setState(() => selectedSubjectItemsList = item)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Row(
                  children: [
                    const Text("select class number"),
                    const SizedBox(
                      width: 11,
                    ),
                    DropdownButton<String>(
                        value: selectedClassItemsList,
                        items: classItemsList
                            .map((item) => DropdownMenuItem(
                                value: item,
                                child: Text(
                                  item,
                                  style: const TextStyle(fontSize: 18),
                                )))
                            .toList(),
                        onChanged: (item) =>
                            setState(() => selectedClassItemsList = item)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextButton(
                    onPressed: () async {
                      setState(() {
                        isLoading = true;
                      });

                      videoName = basename(galleryFile!.path);
                      int random = Random().nextInt(9999999);
                      videoName = "$random$videoName";

                      await FirestoreMethods().addLesson(
                          videoPath: galleryFile,
                          description: desController.text,
                          context: context,
                          videoName: videoName,
                          folderName: "",
                          classNumber: selectedClassItemsList,
                          sybjectType: selectedSubjectItemsList);

                      setState(() {
                        desController.clear();
                        isLoading = false;
                      });
                    },
                    child: isLoading
                        ? const CircularProgressIndicator(
                            color: kPrimaryColor,
                          )
                        : const Text(
                            "Upload",
                            style: TextStyle(
                                color: Colors.blueAccent,
                                fontSize: 19,
                                fontWeight: FontWeight.bold),
                          )),
              )
            ],
          );
        },
      ),
    );
  }

  void _showPicker({
    required BuildContext context,
  }) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () {
                  getVideo(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () {
                  getVideo(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future getVideo(
    ImageSource img,
  ) async {
    final pickedFile = await picker.pickVideo(
        source: img,
        preferredCameraDevice: CameraDevice.front,
        maxDuration: const Duration(minutes: 10));
    xfilePick = pickedFile;
    setState(
      () {
        if (xfilePick != null) {
          galleryFile = File(pickedFile!.path);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(// is this context <<<
              const SnackBar(content: Text('Nothing is selected')));
        }
      },
    );
  }
}
