import 'package:flutter/material.dart';
import 'package:pixabay/view/gallery_page.dart';
import 'package:pixabay/view/state/gallery_controller.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider<GalleryController>(create: (context) => GalleryController()),

      ],
      child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PixaBay',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true),
      home: const GalleryPage(),
    );
  }
}
