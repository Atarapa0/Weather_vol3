import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String apikey="b52a2457f3794d5c935191632240112";
  String city="London";
  String weatherIcon="";
  int temperature=0;
  int windSpeed=0;
  int humidity=0;
  int cloud=0;
  String currentDate="";

  List houryWeatherorecast=[];
  List dailyWeatherForecast=[];

  String currentWeathertatus="";

  //API Call

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather Vol3 '),
      ),
      body: const Center(
        child: Text('Weather Vol3'),
      ),
    );
  }
}
