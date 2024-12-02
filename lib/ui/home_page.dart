import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
//import 'package:flutter_dotenv/flutter_dotenv.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const String apiKey = "b52a2457f3794d5c935191632240112";
  static  String location="London";
  String weatherIcon="";
  int temperature=0;
  int windSpeed=0;
  int humidity=0;
  int cloud=0;
  String currentDate="";

  List houryWeatherforecast=[];
  List dailyWeatherForecast=[];

  String currentWeatherstatus="";

  //API Call
  String searchWeatherApi="https://api.weatherapi.com/v1/current.json?key=$apiKey&q=$location&aqi=no";


  Future<void> fetchWeatherData(String searchText) async {
    try{
      var searchResult=await http.get(Uri.parse(searchWeatherApi +searchText));
      final weatherData=  Map<String,dynamic>.from(
          json.decode(searchResult.body) ?? 'No Data');

      var locationData=weatherData["location"];
      var currentWeather=weatherData["current"];

      setState(() {
        location =getShortLocationName(locationData["name"]);

      });
    }catch(e){
      debugPrint("Error: $e");
    }

    }



  static String  getShortLocationName(String s) {
    List<String> wordlist = s.split(" ");
    if(wordlist.isNotEmpty){
      if(wordlist.length > 1){
        return "${wordlist[0]} ${wordlist[1]}";
      } else {
        return wordlist[0];
      }
    }else{
      return " ";
    }
  }

  @override
  void initState() {
    fetchWeatherData(location);
    super.initState();
    //fetchWeatherData("London"); // Varsayılan şehir Londra
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather Vol3'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Location: $location",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              "Weather: $currentWeatherstatus",
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              "Temperature: $temperature°C",
              style: const TextStyle(fontSize: 18),
            ),

          ],
        ),
      ),
    );
  }
}
