import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class GorakhpurPlacesScreen extends StatefulWidget {
  @override
  _GorakhpurPlacesScreenState createState() => _GorakhpurPlacesScreenState();
}

class _GorakhpurPlacesScreenState extends State<GorakhpurPlacesScreen> {
  List<String> placeNames = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPlaceNames();
  }

  Future<void> fetchPlaceNames() async {
    final String overpassQuery = '''
    [out:json][timeout:25];
    area["name"="Gorakhpur"]["boundary"="administrative"]["admin_level"="6"]->.searchArea;
    (
      node["name"](area.searchArea);
      way["name"](area.searchArea);
      relation["name"](area.searchArea);
    );
    out body;
    >;
    out skel qt;
    ''';

    try {
      final response = await http.post(
        Uri.parse('https://overpass-api.de/api/interpreter'),
        body: {'data': overpassQuery},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final elements = data['elements'] as List;

        final names = <String>{};

        for (var element in elements) {
          if (element['tags'] != null && element['tags']['name'] != null) {
            names.add(element['tags']['name']);
          }
        }

        setState(() {
          placeNames = names.toList()..sort();
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load Overpass data');
      }
    } catch (e) {
      print("Error: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Named Places - Gorakhpur, U.P.')),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : placeNames.isEmpty
          ? Center(child: Text("No named places found."))
          : ListView.builder(
        itemCount: placeNames.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(Icons.place),
            title: Text(placeNames[index]),
          );
        },
      ),
    );
  }
}