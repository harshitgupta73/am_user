import 'package:get/get.dart';

import '../../data/firebase/job_methods/job_method.dart';
import '../../modals/job_model.dart';

class JobController extends GetxController{
  final JobMethods jobMethods = JobMethods();
  final RxList<JobModel> jobs = <JobModel>[].obs;

  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  void startLoading() => isLoading.value=true;
  void stopLoading() => isLoading.value=false;

  @override
  void onInit() {
    super.onInit();
    loadJobs();
  }

  Future<void> loadJobs() async {
    try {
      startLoading();
      final allJobs = await jobMethods.getAllJobs();
      jobs.assignAll(allJobs);
    } catch (e) {
      errorMessage.value = 'Failed to load jobs';
      print("❌ Error loading jobs: $e");
    } finally {
      stopLoading();
    }
  }

  /// Add a new job to Firebase and local list
  Future<void> addJob(JobModel job) async {
    try {
      await jobMethods.addJob(job);
      jobs.insert(0, job); // Insert at top for recent jobs
    } catch (e) {
      print("Error adding job: $e");
    }
  }
}