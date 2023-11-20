// Widget for searching through a string list.
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_sampler/models/locations.dart';

// ignore: must_be_immutable
class SearchNameWidget extends StatefulWidget {
  String? searchText;
  LatLng defaultPosition;
  List<CoffeeShop> coffeeShops;
  Function(String, double, double) onSelectCoffeeShop;

  SearchNameWidget(
      {Key? key,
      this.searchText,
      required this.defaultPosition,
      required this.coffeeShops,
      required this.onSelectCoffeeShop})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SearchNameState createState() => _SearchNameState();
}

class _SearchNameState extends State<SearchNameWidget> {
  final TextEditingController _searchController = TextEditingController();
  List<CoffeeShop> coffeeShopSearchResults = [];
  bool _isSearching = false;

  // changes the filtered name based on search text and sets state.
  void _searchChanged(String searchText) {
    setState(() {
      _isSearching = true;
      if (searchText.isNotEmpty) {
        coffeeShopSearchResults = List.from(widget.coffeeShops.where(
            (coffeeShop) => coffeeShop.name
                .toLowerCase()
                .contains(searchText.toLowerCase())));
      } else {
        coffeeShopSearchResults.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.searchText?.isEmpty == true && !_isSearching) {
      _searchController.text = "";
    }
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15.0),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      blurRadius: 2.0,
                      spreadRadius: 0.4)
                ]),
            child: TextField(
              controller: _searchController,
              style: const TextStyle(fontSize: 15, color: Colors.black),
              onChanged: (search) => _searchChanged(search),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Search...',
                // Add a clear button to the search bar
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    widget.onSelectCoffeeShop(
                        "",
                        widget.defaultPosition.latitude,
                        widget.defaultPosition.longitude);
                  },
                ),
                border: OutlineInputBorder(
                  borderSide:
                      const BorderSide(width: 0, style: BorderStyle.none),
                  borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(15.0),
                      topRight: const Radius.circular(15.0),
                      bottomLeft: Radius.circular(
                          coffeeShopSearchResults.isEmpty ? 15.0 : 0.0),
                      bottomRight: Radius.circular(
                          coffeeShopSearchResults.isEmpty ? 15.0 : 0.0)),
                ),
              ),
            ),
          ),
          if (coffeeShopSearchResults.isNotEmpty)
            Flexible(
              child: Container(
                constraints: const BoxConstraints(maxHeight: 200.0),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(15.0),
                        bottomRight: Radius.circular(15.0)),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          blurRadius: 2.0,
                          spreadRadius: 0.4)
                    ]),
                child: ListView.builder(
                    itemCount: coffeeShopSearchResults.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      CoffeeShop coffeeShop = coffeeShopSearchResults[index];
                      return Container(
                        padding: const EdgeInsets.all(5),
                        child: InkWell(
                          onTap: () {
                            FocusScope.of(context).unfocus();

                            setState(() {
                              _isSearching = false;
                              coffeeShopSearchResults.clear();
                              _searchController.text = coffeeShop.name;
                              widget.onSelectCoffeeShop(coffeeShop.id,
                                  coffeeShop.lat, coffeeShop.lng);
                            });
                          },
                          child: Padding(
                              padding: const EdgeInsets.all(5),
                              child: Text(coffeeShop.name)),
                        ),
                      );
                    }),
              ),
            ),
        ],
      ),
    );
  }
}
