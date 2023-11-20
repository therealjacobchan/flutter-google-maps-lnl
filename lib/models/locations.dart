import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/services.dart' show rootBundle;
import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'locations.g.dart';

@JsonSerializable()
class CoffeeShop with ClusterItem {
  CoffeeShop(
      {required this.address,
      required this.id,
      required this.image,
      required this.lat,
      required this.lng,
      required this.name});

  final double earthRadius = 6371.0; // Radius of the Earth in kilometers

  factory CoffeeShop.fromJson(Map<String, dynamic> json) =>
      _$CoffeeShopFromJson(json);
  Map<String, dynamic> toJson() => _$CoffeeShopToJson(this);

  final String address;
  final String id;
  final String image;
  final double lat;
  final double lng;
  final String name;

  @override
  LatLng get location => LatLng(lat, lng);

  // This is the Haversine distance with respect to current location
  String getDistanceFromCurrentLocation(LatLng currentLocation) {
    // Convert coordinates to radians
    final double lat1 = currentLocation.latitude * (math.pi / 180.0);
    final double lon1 = currentLocation.longitude * (math.pi / 180.0);
    final double lat2 = lat * (math.pi / 180.0);
    final double lon2 = lng * (math.pi / 180.0);

    // Calculate the differences between the coordinates
    final double dLat = lat2 - lat1;
    final double dLon = lon2 - lon1;

    // Apply the Haversine formula
    final double a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(lat1) *
            math.cos(lat2) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);
    final double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    final double distance =
        earthRadius * c; // Distance in kilometers, add "*1000" to get meters

    return distance.toStringAsFixed(2).replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
  }
}

@JsonSerializable()
class Locations {
  Locations({
    required this.coffeeShops,
  });

  factory Locations.fromJson(Map<String, dynamic> json) =>
      _$LocationsFromJson(json);
  Map<String, dynamic> toJson() => _$LocationsToJson(this);

  final List<CoffeeShop> coffeeShops;
}

Future<Locations> getCoffeeShops() async => Locations.fromJson(
      json.decode(
        await rootBundle.loadString('assets/locations.json'),
      ) as Map<String, dynamic>,
    );
