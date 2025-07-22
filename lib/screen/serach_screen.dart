import 'package:am_user/screen/card_deatils_csreen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:am_user/widgets/component/searchBar.dart';
import 'package:am_user/widgets/constants/const.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../controller/controllers.dart';
import '../modals/worker_modal.dart';
import '../responsive/reponsive_layout.dart';
import '../widgets/component/list_deatils_card_for_web.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<WorkerModal> _filteredItems = [];
  final TextEditingController _searchController = TextEditingController();
  final controller =Get.find<Controller>();

  late List<WorkerModal> allWorkers;

  @override
  void initState() {
    super.initState();
    // Generate 20 dummy workers with unique data
    allWorkers = List.generate(20, (index) => WorkerModal(
      workerName: 'Amit Kumar $index',
      address: 'Address $index, Delhi',
      otherSkills: 'Plumbing, Painting',
      selectedGender: 'Male',
      stateValue: 'Delhi',
      distValue: 'Central Delhi',
      workType: ['Plumbing', 'Painting'],
      workerImage: null,
    ));

    _filteredItems = allWorkers;
    // _searchController.addListener(_onSearchChanged);
  }

  // void _onSearchChanged() {
  //   final query = _searchController.text.toLowerCase();
  //   setState(() {
  //     _filteredItems = allWorkers.where((item) {
  //       final nameMatch = item.workerName?.toLowerCase().contains(query) ?? false;
  //       final skillMatch = item.otherSkills?.toLowerCase().contains(query) ?? false;
  //       // final jobMatch = item.jobWork?.toLowerCase().contains(query) ?? false;
  //       // return nameMatch || skillMatch || jobMatch;
  //     }).toList();
  //   });
  // }

  @override
  void dispose() {
    _searchController.dispose();
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
      backgroundColor:backgroundColor,
      body: Column(
        children: [
          const SizedBox(height: 30,),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: CustomSearchbar(
              controller: _searchController,
              label: "Search here",
            ),
          ),
          Expanded(
            child: _filteredItems.isEmpty
                ? const Center(
              child: Text(
                "No Search Results",
                style: TextStyle(color: Colors.white),
              ),
            )
                : GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.allUsers.length,
              shrinkWrap: true,
              padding: Responsive.isMobile(context)
                  ? EdgeInsets.zero
                  : EdgeInsets.all(20),
              gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: Responsive.isMobile(context) ? 1 : 2,
                crossAxisSpacing: Responsive.isMobile(context) ? 0 : 10,
                mainAxisSpacing: Responsive.isMobile(context) ? 0 : 10,
                childAspectRatio:
                Responsive.isDesktop(context)
                    ? 20 / 5
                    : Responsive.isMobile(context)
                    ? 14 / 5
                    : 15 / 5,
              ),
              itemBuilder: (context, index) {
                final users = controller.allUsers[index];
                return InkWell(
                  onTap: () {
                    if (kIsWeb) {
                      // context.push("${RoutsName.cardDetailScreen}?userData=$driver");
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CardDetailsScreen(users:users),
                        ),
                      );
                    }
                  },
                  child: ListDetailsCardForWeb(
                    id:users.id,
                    work: users.type,
                    image: users.image,
                    name: users.name,
                    contact: users.contact,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
