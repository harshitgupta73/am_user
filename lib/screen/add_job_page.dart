import 'dart:io';
import 'dart:math';

import 'package:am_user/widgets/constants/const.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:video_compress/video_compress.dart';

import '../controller/image_picker_controller.dart';
import '../controller/job_controller/job_controller.dart';
import '../data/firebase/storage_services/storage_service.dart';
import '../modals/job_model.dart';

class AddJobPage extends StatefulWidget {
  const AddJobPage({super.key});

  @override
  State<AddJobPage> createState() => _AddJobPageState();
}

class _AddJobPageState extends State<AddJobPage> {

  FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        setState(() {
          selectedType = "text";
        });
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  File? videoThumbnail;

  Future<File?> getVideoThumbnail(String videoPath) async {
    final thumbnail = await VideoCompress.getFileThumbnail(
      videoPath,
      quality: 50, // 0 to 100
      position: -1, // -1 = auto select, or provide seconds (e.g. 2)
    );
    return thumbnail;
  }

  final formattedTime = DateFormat('kk:mm dd/MM/yyyy').format(DateTime.now());

  TextEditingController name = TextEditingController();
  final imagePickerController = Get.find<ImagePickerController>();
  final jobController = Get.find<JobController>();
  final storageServices = StorageServices();

  String? pickedImage;

  String selectedType = '';
  String? pickedFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(title: Text("Add Information"), centerTitle: true),
      body: DefaultTabController(
        length:2 ,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Tab Bar
            TabBar(
              labelColor: Colors.blue,
              unselectedLabelColor: Colors.black,
              indicatorColor: Colors.blue,
              indicatorWeight: 3,
              indicatorSize: TabBarIndicatorSize.label,
              dividerColor: Colors.black,
              tabs: [Tab(text: "Text"), Tab(text: "Image")],
            ),
            SizedBox(height: 20),
            // Tab Views
            Expanded(
              // Set a fixed height or wrap in Expanded if in a flexible parent
              child: TabBarView(
                children: [
                  // TEXT Tab
                  SingleChildScrollView(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                      left: 10, right: 10, top: 10,
                    ),
                    child: Column(
                        children: [
                          TextField(
                              focusNode: _focusNode,
                              cursorColor: Colors.black,
                              controller: name,
                              maxLines: null,
                              keyboardType: TextInputType.multiline,
                              style: TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                labelText: "Enter work content",
                                border: InputBorder.none,
                                labelStyle: TextStyle(color: Colors.black)
                              ),
                            ),
                        ],
                      ),
                    ),

                  // IMAGE Tab
                  Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  onPressed: () async {
                                    final file = await ImagePicker().pickImage(
                                      source: ImageSource.camera,
                                    );
                                    if (file != null) {
                                      setState(() {
                                        selectedType = "image";
                                        pickedImage = file.path;
                                      });
                                    }
                                  },
                                  child: Text("Open Camera"),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  onPressed: () async {
                                    final file = await ImagePicker().pickImage(
                                      source: ImageSource.gallery,
                                    );
                                    if (file != null) {
                                      setState(() {
                                        selectedType = "image";
                                        pickedImage = file.path;
                                      });
                                    }
                                  },
                                  child: Text("Pick Image"),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 20),

                      if (pickedImage != null)
                        Image.file(
                          File(pickedImage!),
                          height: 250,
                          width: double.infinity,
                        ),
                    ],
                  ),

                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          jobController.startLoading();
          if (selectedType == "text" && name.text.isNotEmpty) {
            String jobId =
                FirebaseFirestore.instance.collection("Jobs").doc().id;
            JobModel job = JobModel(jobId: jobId, name: name.text,createdAt: formattedTime);
            if (jobId.isNotEmpty) {
              await jobController.addJob(job);
            }
          } else if (selectedType == "image" && (pickedImage != null)) {
            File file = File(pickedImage!);
            String url = await storageServices.uploadImage(file);

            String jobId =
                FirebaseFirestore.instance.collection("Jobs").doc().id;
            JobModel job = JobModel(jobId: jobId, images: url,createdAt: formattedTime);
            if (jobId.isNotEmpty) {
              await jobController.addJob(job);
            }
          } else if (selectedType == "video" && pickedFile != null) {
            File file = File(pickedFile!);
            String url = await storageServices.uploadVideo(file);
            String jobId =
                FirebaseFirestore.instance.collection("Jobs").doc().id;
            JobModel job = JobModel(jobId: jobId, video: url,createdAt: formattedTime);
            await jobController.addJob(job);
          }

          await jobController.loadJobs();
          context.pop();
          name.clear();
          pickedFile = null;
          pickedImage = null;
          selectedType = '';

          jobController.stopLoading();
        },
        backgroundColor: Colors.blue,
        child: Obx(() => jobController.isLoading.value ? Center(child: CircularProgressIndicator(),) : Text("Add", style: TextStyle(color: Colors.white))),
      ),
    );
  }
}
