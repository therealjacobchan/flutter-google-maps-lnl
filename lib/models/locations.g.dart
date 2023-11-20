// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'locations.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CoffeeShop _$CoffeeShopFromJson(Map<String, dynamic> json) => CoffeeShop(
      address: json['address'] as String,
      id: json['id'] as String,
      image: json['image'] as String,
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
      name: json['name'] as String,
    );

Map<String, dynamic> _$CoffeeShopToJson(CoffeeShop instance) =>
    <String, dynamic>{
      'address': instance.address,
      'id': instance.id,
      'image': instance.image,
      'lat': instance.lat,
      'lng': instance.lng,
      'name': instance.name,
    };

Locations _$LocationsFromJson(Map<String, dynamic> json) => Locations(
      coffeeShops: (json['coffeeShops'] as List<dynamic>)
          .map((e) => CoffeeShop.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$LocationsToJson(Locations instance) => <String, dynamic>{
      'coffeeShops': instance.coffeeShops,
    };
