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
  static const String baseUrl = "https://api.weatherapi.com/v1/current.json";
  String location = "Loading...";
  String weatherStatus = "Loading...";
  int temperature = 0;

  Future<void> fetchWeatherData(String searchText) async {
    try {
      final String url = "$baseUrl?key=$apiKey&q=$searchText&aqi=no";
      var searchResult = await http.get(Uri.parse(url));

      if (searchResult.statusCode == 200) {
        final weatherData = json.decode(searchResult.body) as Map<String, dynamic>;
        final locationData = weatherData["location"];
        final currentWeather = weatherData["current"];

        setState(() {
          location = locationData["name"];
          weatherStatus = currentWeather["condition"]["text"];
          temperature = currentWeather["temp_c"].toInt();
        });
      } else {
        setState(() {
          location = "Error: ${searchResult.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        location = "Error fetching data.";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchWeatherData("London"); // Varsayılan şehir Londra
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
              "Weather: $weatherStatus",
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

void main() {
  runApp(const MaterialApp(
    home: HomePage(),
  ));
}
