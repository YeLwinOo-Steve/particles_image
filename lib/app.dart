import 'package:flutter/material.dart';

import 'widgets/particle_image_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ParticleImagePage(),
    );
  }
}
