import 'package:am_user/widgets/component/searchBar.dart';
import 'package:flutter/material.dart';

import '../modals/worker_modal.dart';
import '../widgets/component/list_deatils_card_for_web.dart';

class JobSearchScreen extends StatefulWidget {
  @override
  _JobSearchScreenState createState() => _JobSearchScreenState();
}

class _JobSearchScreenState extends State<JobSearchScreen> {
  List<WorkerModal> _filteredItems = [];
  final TextEditingController _searchController = TextEditingController();

  static List<WorkerModal> allWorkers = [];

  @override
  void initState() {
    super.initState();
    allWorkers = List.generate(20, (index) => WorkerModal(
      workerName: 'Amit Kumar $index',
      address: 'Address $index, Delhi',
      otherSkills: 'Plumbing, Painting',
      workerContat: '6320185485',
      selectedGender: 'Male',
      stateValue: 'Delhi',
      distValue: 'Central Delhi',
      jobWorkCategory: 'Construction',
      jobWork: 'Mason',
      workerImage: null,
    ),);
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredItems = allWorkers.where((item) {
        return item.workerName!.toLowerCase().contains(query) ||
            item.otherSkills!.split(',').any((skill) => skill.toLowerCase().contains(query));
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,  // always dark
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          "Search",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: CustomSearchbar(
              controller: _searchController,
              label: "Search here",
              // if your CustomSearchbar supports colors, you can pass backgroundColor and textColor also
            ),
          ),
          Expanded(
            child: _filteredItems.isEmpty
                ? Center(
              child: Text(
                "No Search Results",
                style: TextStyle(color: Colors.white),
              ),
            )
                : ListView.builder(
              itemCount: _filteredItems.length,
              itemBuilder: (ctx, index) {
                final item = _filteredItems[index];
                return ListDetailsCardForWeb(
                  work: item.otherSkills!,
                  image: item.workerImage,
                  name: item.workerName,
                  contact: item.workerContat,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
