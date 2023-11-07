import 'package:flutter/material.dart';
import 'package:save_data_app/pages/gather/save_string_and_list_and_bool_and_int.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SaveStringAndListAndBoolAndInt(),
    );
  }
}
