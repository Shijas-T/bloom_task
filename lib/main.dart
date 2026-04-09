import 'package:bloom_task/ui/collection_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bloop',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const CollectionListScreen(),
    );
  }
}
