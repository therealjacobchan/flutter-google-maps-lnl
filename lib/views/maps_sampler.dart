import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_sampler/views/default_loader.dart';
import 'package:maps_sampler/views/map_view.dart';
import 'package:maps_sampler/views/selected_marker_card.dart';
import 'package:maps_sampler/models/locations.dart' as locations;
import 'custom_marker.dart' as custom_marker;

class MapsSampler extends StatefulWidget {
  const MapsSampler({super.key});

  @override
  State<MapsSampler> createState() => _MapsSamplerState();
}

class _MapsSamplerState extends State<MapsSampler> {
  late GoogleMapController mapController;
  late ClusterManager<locations.CoffeeShop> clusterManager;

  final List<locations.CoffeeShop> coffeeShops = [];
  final LatLng _default = const LatLng(14.599512,
      120.984222); // Current location by default (applies only to emulator)

  Set<Marker> markers = {};
  LatLng? _currentPosition;
  locations.CoffeeShop? selectedCoffeeShop;

  @override
  void initState() {
    super.initState();

    _getUserCurrentLocation();

    clusterManager = ClusterManager<locations.CoffeeShop>(
      coffeeShops,
      _updateMarkers,
      markerBuilder: _getMarkerBuilder,
    );
  }

  void _updateMarkers(Set<Marker> markers) =>
      setState(() => this.markers = markers);

  // We build the markers here. Based on whether it is a cluster or now, we display either
  // the default marker or the cluster marker
  Future<Marker> _getMarkerBuilder(
          Cluster<locations.CoffeeShop> cluster) async =>
      Marker(
        markerId: MarkerId(cluster.getId()),
        position: cluster.location,
        onTap: () async {
          if (cluster.isMultiple) {
            double zoomLevel = await mapController.getZoomLevel();
            mapController.animateCamera(
                CameraUpdate.newLatLngZoom(cluster.location, zoomLevel + 2.5));
          } else {
            setState(() => selectedCoffeeShop = cluster.items.first);
            clusterManager.updateMap();
          }
        },
        icon: !cluster.isMultiple
            ? cluster.items.first.id == selectedCoffeeShop?.id
                ? BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueGreen)
                : BitmapDescriptor.defaultMarker
            : await custom_marker.getMarkerBitmap(125,
                text: cluster.count.toString()),
      );

  // Called upon creation of the Google Maps
  Future<void> _onMapCreated(GoogleMapController controller) async {
    final coffeeShopLocations = await locations.getCoffeeShops();
    coffeeShops.addAll(coffeeShopLocations.coffeeShops);
    mapController = controller;
    clusterManager.setMapId(controller.mapId);
  }

  // Created method for getting user current location
  void _getUserCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    switch (permission) {
      case LocationPermission.always:
      case LocationPermission.whileInUse:
        Position position = await Geolocator.getCurrentPosition();
        setState(() =>
            _currentPosition = LatLng(position.latitude, position.longitude));
      default:
        await Geolocator.requestPermission()
            .then((value) => _getUserCurrentLocation());
        break;
    }
  }

  void _onTapMapOutside(LatLng latLng) =>
      setState(() => selectedCoffeeShop = null);

  @override
  Widget build(BuildContext context) => SafeArea(
        left: false,
        right: false,
        top: false,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Maps Sample App'),
            elevation: 2,
          ),
          body: _currentPosition == null
              ? const DefaultLoaderView()
              : Stack(
                  children: [
                    MapView(
                      coffeeShops,
                      markers,
                      clusterManager,
                      searchText: selectedCoffeeShop?.name ?? "",
                      defaultPosition: _default,
                      currentPosition: _currentPosition,
                      onMapCreated: _onMapCreated,
                      onTapMapOutside: _onTapMapOutside,
                      onSelectCoffeeShop: (id, lat, lng) => setState(
                        () {
                          if (id.isNotEmpty) {
                            selectedCoffeeShop = coffeeShops.firstWhere(
                                (coffeeShop) => coffeeShop.id == id);
                            mapController.moveCamera(CameraUpdate.newLatLngZoom(
                                LatLng(lat, lng), 20.0));
                          } else {
                            selectedCoffeeShop = null;
                          }
                        },
                      ),
                    ),
                    if (selectedCoffeeShop != null)
                      SelectedMarkerCard(
                          currentPosition: _currentPosition ?? _default,
                          selectedCoffeeShop: selectedCoffeeShop)
                  ],
                ),
          floatingActionButton: Padding(
            padding:
                EdgeInsets.only(bottom: selectedCoffeeShop != null ? 140 : 50),
            child: FloatingActionButton(
              onPressed: () async {
                setState(() => selectedCoffeeShop = null);
                _getUserCurrentLocation();
                mapController.animateCamera(CameraUpdate.newLatLngZoom(
                    _currentPosition ?? _default, 13.0));
              },
              backgroundColor: Colors.green[50],
              child: const Icon(Icons.my_location_outlined),
            ),
          ),
        ),
      );
}
