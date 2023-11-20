import 'package:flutter/material.dart';

class DefaultLoaderView extends StatelessWidget {
  const DefaultLoaderView({super.key});

  @override
  Widget build(BuildContext context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator.adaptive(),
            const SizedBox(height: 20),
            Text(
              'Loading map...',
              style: TextStyle(
                  fontFamily: 'Avenir-Medium', color: Colors.grey[400]),
            )
          ],
        ),
      );
}
