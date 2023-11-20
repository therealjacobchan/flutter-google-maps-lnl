import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_sampler/models/locations.dart';

class SelectedMarkerCard extends StatelessWidget {
  const SelectedMarkerCard(
      {super.key, required this.currentPosition, this.selectedCoffeeShop});

  final LatLng currentPosition;
  final CoffeeShop? selectedCoffeeShop;

  @override
  Widget build(BuildContext context) => Container(
        alignment: Alignment.bottomCenter,
        child: Container(
          margin: const EdgeInsets.only(bottom: 10, left: 16, right: 16),
          child: Card(
            elevation: 10,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Image.network(
                    selectedCoffeeShop?.image ?? "",
                    width: 100,
                    height: 100,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          selectedCoffeeShop?.name ?? "",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(selectedCoffeeShop?.address ?? "",
                            style: TextStyle(color: Colors.grey[700])),
                        Text(
                            "${selectedCoffeeShop?.getDistanceFromCurrentLocation(currentPosition)} km"),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      );
}
