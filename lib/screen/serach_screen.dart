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
  final TextEditingController _searchController = TextEditingController();
  final controller = Get.find<Controller>();
  final SearchController searchController = Get.put(SearchController());

  @override
  void initState() {
    super.initState();
    controller.getAllUsers();
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

  void _triggerSearch() {
    final query = _searchController.text.trim().toLowerCase();
    if (query.isNotEmpty) {
      searchController.runSearch(query);
    } else {
      searchController.allResults.clear();
    }
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
      body: Column(
        children: [
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(21),
                    borderSide: BorderSide.none,
                  ),

                  hintText: "Search",
                  hintStyle: TextStyle(color: Colors.black),
                  suffixIcon: GestureDetector(
                    onTap: () {
                      _triggerSearch();
                    },
                    child: Icon(Icons.search, color: Colors.black),
                  ),
                ),
                cursorColor: Colors.black,
                onSubmitted: (_) => _triggerSearch(),
                controller: _searchController,
                onChanged: (value) {
                  if (value.isEmpty) {
                    searchController.allResults.clear();
                  }
                },
              ),
            ),
          ),
          Expanded(
            child: Obx(() {
              if (searchController.isLoading.value) {
                return const Center(child: CircularProgressIndicator(color: Colors.black,));
              }

              final results =
                  searchController.allResults.isNotEmpty
                      ? searchController.allResults
                      : controller.allUsers;

              if (results.isEmpty) {
                return const Center(child: CircularProgressIndicator(color: Colors.black,));
              }

              return GridView.builder(
                itemCount: results.length,
                shrinkWrap: true,
                padding:
                    Responsive.isMobile(context)
                        ? EdgeInsets.zero
                        : const EdgeInsets.all(20),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
                  final user = results[index];

                  return InkWell(
                    onTap: () {
                      if (kIsWeb) {
                        // Navigate on web
                      } else {
                        // Navigate on mobile
                      }
                    },
                    child: ListDetailsCardForWeb(
                      id: user.id,
                      name: user.name,
                      contact: user.contact,
                      work: user.type,
                      image: user.image,
                      distance: user.distance,
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
