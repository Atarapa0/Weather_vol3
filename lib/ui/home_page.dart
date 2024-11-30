import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String apikey="26475ac066314d0baa3130732243011";
  String city="London";
  String weatherIcon="";
  int temperature=0;
  int windSpeed=0;
  int humidity=0;
  int cloud=0;
  String currentDate="";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather Vol3 '),
      ),
      body: const Center(
        child: Text('Hello, World!aa'),
      ),
    );
  }
}
