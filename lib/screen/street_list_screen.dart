import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire3/geoflutterfire3.dart';
import 'package:location/location.dart';

class GorakhpurPlacesScreen extends StatefulWidget {
  @override
  _GorakhpurPlacesScreenState createState() => _GorakhpurPlacesScreenState();
}

class _GorakhpurPlacesScreenState extends State<GorakhpurPlacesScreen> {
  final geo = GeoFlutterFire();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> updateUserLocation(String userId) async {
    Location location = Location();

    // Request permission
    PermissionStatus permissionGranted = await location.requestPermission();
    if (permissionGranted != PermissionStatus.granted) return;

    // Get current location
    LocationData locData = await location.getLocation();
    double latitude = locData.latitude!;
    double longitude = locData.longitude!;

    // Create GeoFirePoint
    GeoFirePoint myLocation = geo.point(latitude: latitude, longitude: longitude);

    // Save to Firestore
    await firestore.collection('users_c').doc(userId).set({
      'name': 'John Doe',
      'position': myLocation.data,
      'lastUpdated': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> queryNearbyUsers(double lat, double lng,
      double radiusInKm) async {
    GeoFirePoint center = geo.point(latitude: lat, longitude: lng);

    var collectionRef = firestore.collection('users_c');

    final stream = geo.collection(collectionRef: collectionRef)
        .within(
      center: center,
      radius: radiusInKm,
      field: 'position',
      strictMode: true,
    );

    stream.listen((List<DocumentSnapshot> documentList) {
      for (var doc in documentList) {
        print('Nearby user: ${doc.data()}');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Center(
        child: Column(
          children: [
            SizedBox(height: 100,),
            ElevatedButton(
              onPressed: () async {
                // Save current user's location
                await updateUserLocation('user125');
              },
              child: Text('Save Users'),
            ),
            ElevatedButton(
              onPressed: () async {
                // Query users within 5 km
                LocationData location = await Location().getLocation();
                await queryNearbyUsers(location.latitude!, location.longitude!, 5);
              },
              child: Text('Find Nearby Users'),
            ),
          ],
        ),
      ),
    );
  }
}