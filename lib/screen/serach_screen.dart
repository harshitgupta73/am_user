import 'package:am_user/screen/card_deatils_csreen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide SearchController;
import 'package:am_user/widgets/constants/const.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../controller/controllers.dart';
import '../controller/searchController/search_controller.dart';
import '../responsive/reponsive_layout.dart';
import '../widgets/component/list_deatils_card_for_web.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  // List<WorkerModal> _filteredItems = [];
  final TextEditingController _searchController = TextEditingController();
  final controller =Get.find<Controller>();
  final SearchController searchController = Get.put(SearchController());

  // late List<WorkerModal> allWorkers;

  @override
  void initState() {
    super.initState();

    // _filteredItems = allWorkers;
    // _searchController.addListener();
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
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black,width: 1),
                borderRadius: BorderRadius.circular(12)
              ),
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(21),
                    borderSide: BorderSide.none,
                  ),
                  hintText: "Search",
                  hintStyle: TextStyle(color: Colors.black),
                  suffixIcon: GestureDetector(
                    onTap: () {
                      final query = _searchController.text.trim().toLowerCase();
                      if (query.isNotEmpty) {
                        searchController.runSearch(query);
                      }
                    },
                    child: Icon(Icons.search, color: Colors.black),
                  ),
                ),
                cursorColor: Colors.black,
                controller: _searchController,
                  onChanged: (value) {
                    final query = value.trim().toLowerCase();
                    if (query.isEmpty) {
                      searchController.allResults.clear();
                    } else {
                      searchController.runSearch(query);
                    }
                },
              ),
            )
          ),
          // Expanded(
          //   child: searchController.allResults.isNotEmpty
          //       ? GridView.builder(
          //     physics: const NeverScrollableScrollPhysics(),
          //     itemCount: searchController.allResults.length,
          //     shrinkWrap: true,
          //     padding: Responsive.isMobile(context)
          //         ? EdgeInsets.zero
          //         : EdgeInsets.all(20),
          //     gridDelegate:
          //     SliverGridDelegateWithFixedCrossAxisCount(
          //       crossAxisCount: Responsive.isMobile(context) ? 1 : 2,
          //       crossAxisSpacing: Responsive.isMobile(context) ? 0 : 10,
          //       mainAxisSpacing: Responsive.isMobile(context) ? 0 : 10,
          //       childAspectRatio:
          //       Responsive.isDesktop(context)
          //           ? 20 / 5
          //           : Responsive.isMobile(context)
          //           ? 14 / 5
          //           : 15 / 5,
          //     ),
          //     itemBuilder: (context, index) {
          //       final users = searchController.allResults[index];
          //       return InkWell(
          //         onTap: () {
          //           if (kIsWeb) {
          //             // context.push("${RoutsName.cardDetailScreen}?userData=$driver");
          //           } else {
          //             Navigator.push(
          //               context,
          //               MaterialPageRoute(
          //                 builder: (context) => CardDetailsScreen(users:AllUserModal(name: users.name, contact: users.contact, type: users.type, id: users.id, image: users.image,)),
          //               ),
          //             );
          //           }
          //         },
          //         child: ListDetailsCardForWeb(
          //             name: users.name,
          //             contact: users.contact,
          //             work: users.type,
          //             image: users.image,
          //           id: users.id,
          //         ),
          //       );
          //     },
          //   )
          //       : GridView.builder(
          //     physics: const NeverScrollableScrollPhysics(),
          //     itemCount: controller.allUsers.length,
          //     shrinkWrap: true,
          //     padding: Responsive.isMobile(context)
          //         ? EdgeInsets.zero
          //         : EdgeInsets.all(20),
          //     gridDelegate:
          //     SliverGridDelegateWithFixedCrossAxisCount(
          //       crossAxisCount: Responsive.isMobile(context) ? 1 : 2,
          //       crossAxisSpacing: Responsive.isMobile(context) ? 0 : 10,
          //       mainAxisSpacing: Responsive.isMobile(context) ? 0 : 10,
          //       childAspectRatio:
          //       Responsive.isDesktop(context)
          //           ? 20 / 5
          //           : Responsive.isMobile(context)
          //           ? 14 / 5
          //           : 15 / 5,
          //     ),
          //     itemBuilder: (context, index) {
          //       final users = controller.allUsers[index];
          //       return InkWell(
          //         onTap: () {
          //           if (kIsWeb) {
          //             // context.push("${RoutsName.cardDetailScreen}?userData=$driver");
          //           } else {
          //             Navigator.push(
          //               context,
          //               MaterialPageRoute(
          //                 builder: (context) => CardDetailsScreen(users:users),
          //               ),
          //             );
          //           }
          //         },
          //         child: ListDetailsCardForWeb(
          //           id:users.id,
          //           work: users.type,
          //           image: users.image,
          //           name: users.name,
          //           contact: users.contact,
          //         ),
          //       );
          //     },
          //   ),
          // ),
          Expanded(
            child: Obx(() => GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: searchController.allResults.isNotEmpty
                  ? searchController.allResults.length
                  : controller.allUsers.length,
              shrinkWrap: true,
              padding: Responsive.isMobile(context)
                  ? EdgeInsets.zero
                  : EdgeInsets.all(20),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: Responsive.isMobile(context) ? 1 : 2,
                crossAxisSpacing: Responsive.isMobile(context) ? 0 : 10,
                mainAxisSpacing: Responsive.isMobile(context) ? 0 : 10,
                childAspectRatio: Responsive.isDesktop(context)
                    ? 20 / 5
                    : Responsive.isMobile(context)
                    ? 14 / 5
                    : 15 / 5,
              ),
              itemBuilder: (context, index) {
                final users = searchController.allResults.isNotEmpty
                    ? searchController.allResults[index]
                    : controller.allUsers[index];

                return InkWell(
                  onTap: () {
                    if (kIsWeb) {
                      // Web routing if needed
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CardDetailsScreen(users: users),
                        ),
                      );
                    }
                  },
                  child: ListDetailsCardForWeb(
                    id: users.id,
                    name: users.name,
                    contact: users.contact,
                    work: users.type,
                    image: users.image,
                  ),
                );
              },
            )),
          ),
        ],
      ),
    );
  }
}
