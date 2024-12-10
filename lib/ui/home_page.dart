import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:weathervol3/components/weather_item.dart';
import 'package:weathervol3/constants.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:weathervol3/ui/detail_page.dart';
//import 'package:flutter_dotenv/flutter_dotenv.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _cityController = TextEditingController();
  final Constants _constants = Constants();
  //static String? apiKey = dotenv.env['API_KEY'];
  static String? apiKey = dotenv.env['API_KEY'] ?? '';
  static String location = "London";
  String weatherIcon = "";
  int temperature = 0;
  int windSpeed = 0;
  int humidity = 0;
  int cloud = 0;
  String currentDate = "";

  List houryWeatherforecast = [];
  List dailyWeatherForecast = [];

  String currentWeatherstatus = " ";

  //API Call
  String searchWeatherApi =
      "https://api.weatherapi.com/v1/forecast.json?key=$apiKey&q=$location&aqi=no";

  Future<void> fetchWeatherData(String searchText) async {
    try {
      var searchResult =
          await http.get(Uri.parse(searchWeatherApi + searchText));
      final weatherData = Map<String, dynamic>.from(
          json.decode(searchResult.body) ?? 'No Data');

      var locationData = weatherData["location"];
      var currentWeather = weatherData["current"];
      var forecastData = weatherData["forecast"];

      setState(() {
        location = getShortLocationName(locationData["name"]);
        var parseDate =
            DateTime.parse(locationData["localtime"].substring(0, 10));
        var newDate = DateFormat('MMMMEEEEd').format(parseDate);
        currentDate = newDate;

        //update Weather
        currentWeatherstatus = currentWeather["condition"]["text"];
        weatherIcon =
            "${currentWeatherstatus.replaceAll(' ', '').toLowerCase()}.png";
        temperature = currentWeather["temp_c"].toInt();
        windSpeed = currentWeather["wind_kph"].toInt();
        humidity = currentWeather["humidity"].toInt();
        cloud = currentWeather["cloud"].toInt();

        //forecast data
        dailyWeatherForecast = forecastData["forecastday"];
        houryWeatherforecast = dailyWeatherForecast[0]["hour"];

        //print(dailyWeatherForecast);
      });
    } catch (e) {
      debugPrint("Error : $e");
    }
  }

// function to get the first two words of the location
  static String getShortLocationName(String s) {
    List<String> wordlist = s.split(" ");
    if (wordlist.isNotEmpty) {
      if (wordlist.length > 1) {
        return "${wordlist[0]} ${wordlist[1]}";
      } else {
        return wordlist[0];
      }
    } else {
      return " ";
    }
  }

  @override
  void initState() {
    fetchWeatherData(location);
    super.initState();

    //fetchWeatherData("London"); //Default city is London
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);

    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: size.width,
        height: size.height,
        padding: const EdgeInsets.only(top: 70, left: 10, right: 10),
        color: _constants.primaryColor.withOpacity(.1),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              height: size.height * .7,
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
              child: Column(
                //crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/menu.png",
                        width: 40,
                        height: 40,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/pin.png",
                            width: 20,
                          ),
                          const SizedBox(
                            width: 2,
                          ),
                          Text(
                            location,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              _cityController.clear();
                              showMaterialModalBottomSheet(
                                  context: context,
                                  builder: (context) => SingleChildScrollView(
                                        controller:
                                            ModalScrollController.of(context),
                                        child: Container(
                                          height: size.height * .2,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 20,
                                            vertical: 10,
                                          ),
                                          child: Column(
                                            children: [
                                              SizedBox(
                                                width: 70,
                                                child: Divider(
                                                  thickness: 3.5,
                                                  color:
                                                      _constants.primaryColor,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              TextField(
                                                onChanged: (searchText) {
                                                  fetchWeatherData(searchText);
                                                },
                                                controller: _cityController,
                                                autofocus: true,
                                                decoration: InputDecoration(
                                                  prefixIcon: Icon(
                                                    Icons.search,
                                                    color:
                                                        _constants.primaryColor,
                                                  ),
                                                  suffixIcon: GestureDetector(
                                                    onTap: () =>
                                                        _cityController.clear(),
                                                    child: Icon(
                                                      Icons.close,
                                                      color: _constants
                                                          .primaryColor,
                                                    ),
                                                  ),
                                                  hintText:
                                                      'Search City e.g London',
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: _constants
                                                          .primaryColor,
                                                      width: 2,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ));
                            },
                            icon: const Icon(
                              Icons.keyboard_arrow_down,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          "assets/avatar.png",
                          width: 40,
                          height: 40,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 160,
                    child: Image.asset("assets/$weatherIcon"),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(temperature.toString(),
                            style: TextStyle(
                              fontSize: 80,
                              fontWeight: FontWeight.bold,
                              foreground: Paint()..shader = _constants.shader,
                            )),
                      ),
                      Text('°',
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            foreground: Paint()..shader = _constants.shader,
                          )),
                    ],
                  ),
                  Text(
                    currentWeatherstatus,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    currentDate,
                    style: const TextStyle(
                      color: Colors.white70,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Divider(
                      color: Colors.white70,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        WeatherItem(
                          value: windSpeed.toInt(),
                          unit: "km/h",
                          ImageUrl: "assets/windy.png",
                        ),
                        WeatherItem(
                          value: humidity.toInt(),
                          unit: "%",
                          ImageUrl: "assets/humidity.png",
                        ),
                        WeatherItem(
                          value: cloud.toInt(),
                          unit: "%",
                          ImageUrl: "assets/cloudy-night.png",
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 10),
              height: size.height * .2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Today',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      GestureDetector(
                        onTap: () =>
                        Navigator.push(context,MaterialPageRoute(builder: (_)=>DetailPage(dailyForecastWeather:dailyWeatherForecast))),
                        child: Text(
                          'Forecast',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: _constants.primaryColor,
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 110,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemCount: houryWeatherforecast
                          .length, // Ensure the itemCount is set
                      itemBuilder: (BuildContext context, int index) {
                        if (index >= houryWeatherforecast.length) {
                          return Container(); // Return an empty container if index is out of range
                        }

                        String currenttime =
                            DateFormat('HH:mm:ss').format(DateTime.now());
                        String currentHour = currenttime.substring(0, 2);

                        String forecastTime = houryWeatherforecast[index]
                                ["time"]
                            .substring(11, 16);
                        String forecastHour = houryWeatherforecast[index]
                                ["time"]
                            .substring(11, 13);

                        String forecastWeatherName =
                            houryWeatherforecast[index]["condition"]["text"];
                        String forecastWeatherIcon =
                            "${forecastWeatherName.replaceAll(' ', '').toLowerCase()}.png";
                        print(
                            forecastWeatherIcon); // Hangi dosya yolu dönüyor, kontrol edin.
                        print(forecastTime);
                        String forecastTemperature = houryWeatherforecast[index]
                                ["temp_c"]
                            .round()
                            .toString();
                        return Container(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          margin: const EdgeInsets.only(right: 20),
                          width: 65,
                          decoration: BoxDecoration(
                            color: currentHour == forecastHour
                                ? Colors.white
                                : _constants.primaryColor,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(50)),
                            boxShadow: [
                              BoxShadow(
                                offset: const Offset(0, 1),
                                blurRadius: 5,
                                color: _constants.primaryColor.withOpacity(.2),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                forecastTime,
                                style: TextStyle(
                                  fontSize: 17,
                                  color: _constants.greyColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Image.asset('assets/$forecastWeatherIcon',
                                  width: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    forecastTemperature,
                                    style: TextStyle(
                                      fontSize: 17,
                                      color: _constants.greyColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    '°',
                                    style: TextStyle(
                                      fontSize: 17,
                                      color: _constants.greyColor,
                                      fontWeight: FontWeight.w500,
                                      fontFeatures: const [
                                        FontFeature.enable('sups'),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
