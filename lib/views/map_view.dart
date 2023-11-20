import 'package:flutter/material.dart';
import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_sampler/models/locations.dart';
import 'package:maps_sampler/views/search_bar.dart';

class MapView extends StatelessWidget {
  const MapView(
    this.coffeeShops,
    this.markers,
    this.clusterManager, {
    super.key,
    this.currentPosition,
    required this.defaultPosition,
    this.onMapCreated,
    required this.searchText,
    required this.onSelectCoffeeShop,
    required this.onTapMapOutside,
  });

  final String? searchText;
  final List<CoffeeShop> coffeeShops;
  final Set<Marker> markers;
  final ClusterManager clusterManager;
  final LatLng? currentPosition;
  final LatLng defaultPosition;
  final Function(GoogleMapController)? onMapCreated;
  final Function(String, double, double) onSelectCoffeeShop;
  final Function(LatLng) onTapMapOutside;

  LatLng get position => currentPosition ?? defaultPosition;

  @override
  Widget build(BuildContext context) => Stack(
        children: [
          GoogleMap(
            onMapCreated: onMapCreated,
            onCameraMove: (position) => clusterManager.onCameraMove(position),
            onCameraIdle: clusterManager.updateMap,
            rotateGesturesEnabled: false,
            myLocationButtonEnabled: false,
            myLocationEnabled: true,
            compassEnabled: false,
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
            markers: markers,
            onTap: (position) {
              clusterManager.updateMap();
              onTapMapOutside(position);
            },
            initialCameraPosition: CameraPosition(
              target: position,
              zoom: 13.0,
            ),
          ),
          SearchNameWidget(
            searchText: searchText,
            defaultPosition: position,
            coffeeShops: coffeeShops,
            onSelectCoffeeShop: onSelectCoffeeShop,
          ),
        ],
      );
}
