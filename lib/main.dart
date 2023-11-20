import 'package:flutter/material.dart';
import 'package:maps_sampler/views/maps_sampler.dart';

void main() => runApp(const MapsSamplerApp());

class MapsSamplerApp extends StatelessWidget {
  const MapsSamplerApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: Colors.green[700],
        ),
        home: const MapsSampler(),
      );
}
