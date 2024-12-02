import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:weathervol3/constants.dart';
//import 'package:flutter_dotenv/flutter_dotenv.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Constants _constants = Constants();
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
  String searchWeatherApi="https://api.weatherapi.com/v1/forecast.json?key=$apiKey&q=$location&aqi=no";


  Future<void> fetchWeatherData(String searchText) async {
    try{
      var searchResult=await http.get(Uri.parse(searchWeatherApi +searchText));
      final weatherData=  Map<String,dynamic>.from(
          json.decode(searchResult.body) ?? 'No Data');

      var locationData=weatherData["location"];
      var currentWeather=weatherData["current"];
      var forecastData = weatherData["forecast"];


      setState(() {
        location =getShortLocationName(locationData["name"]);
        var parseDate=DateTime.parse(locationData["localtime"].substring(0,10));
        var newDate=DateFormat('MMMMEEEEd').format(parseDate);
        currentDate=newDate;

        //update Weather
        currentWeatherstatus=currentWeather["condition"]["text"];
        //weatherIcon=currentWeatherstatus.replaceAll('', '').toLowerCase()+".png";
        weatherIcon="https:${currentWeather["condition"]["icon"]}";
        temperature=currentWeather["temp_c"].toInt();
        windSpeed=currentWeather["wind_kph"].toInt();
        humidity=currentWeather["humidity"].toInt();
        cloud=currentWeather["cloud"].toInt();

        //forecast data
        dailyWeatherForecast=forecastData["forecastday"];
        houryWeatherforecast=dailyWeatherForecast[0]["hour"];

        //print(dailyWeatherForecast);

      });
    }catch(e){
      debugPrint("Error : $e");
    }

    }


// function to get the first two words of the location
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
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);

    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: size.width,
        height: size.height,
        padding: const EdgeInsets.only(top:70,left: 10,right: 10),
        color: _constants.primaryColor.withOpacity(.1),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
              height: size.height*.7,
              decoration: BoxDecoration(
                gradient: _constants.linearGradientBlue,
                boxShadow: [
                  BoxShadow(
                    color: _constants.primaryColor.withOpacity(.5),
                    blurRadius: 7,
                    spreadRadius: 5,
                    offset: const Offset(0, 5),
                  )
                ],
                borderRadius: BorderRadius.circular(20),
              ),
            )
          ],
        ),
      ),

    );
  }
}
