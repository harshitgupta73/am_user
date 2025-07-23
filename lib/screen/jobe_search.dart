import 'dart:io';

import 'package:am_user/controller/image_picker_controller.dart';
import 'package:am_user/controller/job_controller/job_controller.dart';
import 'package:am_user/data/firebase/storage_services/storage_service.dart';
import 'package:am_user/widgets/component/job_list_card.dart';
import 'package:am_user/widgets/constants/const.dart';
import 'package:am_user/widgets/routs/routs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../modals/worker_modal.dart';

class JobSearchScreen extends StatefulWidget {
  @override
  _JobSearchScreenState createState() => _JobSearchScreenState();
}

class _JobSearchScreenState extends State<JobSearchScreen> {

  final imagePickerController = Get.find<ImagePickerController>();
  final jobController = Get.find<JobController>();

  final StorageServices storageServices = StorageServices();

  @override
  void initState() {
    super.initState();
    jobController.loadJobs();
  }


  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.black, // status bar background
        statusBarIconBrightness: Brightness.dark, // icons: time, battery
      ),
    );
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text("Information",style: TextStyle(color: Colors.black),),
        centerTitle: true,
        backgroundColor: backgroundColor,
        iconTheme: IconThemeData(
          color: Colors.black, // Change this to your desired color
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 15,),
          Expanded(
            child: Obx(() {
              if (jobController.isLoading.value) {
                return const Center(child: CircularProgressIndicator(color: Colors.white));
              }

              if (jobController.jobs.isEmpty) {
                return Center(
                  child: Text(
                    jobController.errorMessage.value.isNotEmpty
                        ? jobController.errorMessage.value
                        : "No Search Results",
                    style: const TextStyle(color: Colors.white),
                  ),
                );
              }

              return ListView.builder(
                itemCount: jobController.jobs.length,
                itemBuilder: (ctx, index) {
                  final item = jobController.jobs[index];
                  return JobListCard(item: item);
                },
              );
            }),

          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        child: Icon(Icons.add, color: Colors.white),
        onPressed: () {
          context.push(RoutsName.addJob);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

}
