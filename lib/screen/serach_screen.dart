import 'package:flutter/material.dart';
import 'package:am_user/widgets/component/searchBar.dart';
import 'package:am_user/widgets/constants/const.dart';

import '../modals/worker_modal.dart';
import '../widgets/component/list_deatils_card_for_web.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<WorkerModal> _filteredItems = [];
  final TextEditingController _searchController = TextEditingController();

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
      jobWorkCategory: 'Construction',
      jobWork: 'Mason',
      workerImage: null,
    ));

    _filteredItems = allWorkers;
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredItems = allWorkers.where((item) {
        final nameMatch = item.workerName?.toLowerCase().contains(query) ?? false;
        final skillMatch = item.otherSkills?.toLowerCase().contains(query) ?? false;
        final jobMatch = item.jobWork?.toLowerCase().contains(query) ?? false;
        return nameMatch || skillMatch || jobMatch;
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
      backgroundColor: Colors.black, // always dark
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          "Search",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(
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
                : ListView.builder(
              itemCount: _filteredItems.length,
              itemBuilder: (ctx, index) {
                final item = _filteredItems[index];
                return ListDetailsCardForWeb(
                  work: item.jobWork ?? '',
                  image: item.workerImage,
                  name: item.workerName ?? '',
                  contact: '', // Add contact if available in your model
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
