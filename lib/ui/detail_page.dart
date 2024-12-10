import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weathervol3/components/weather_item.dart';
import 'package:weathervol3/constants.dart';

class DetailPage extends StatefulWidget {
  final List<dynamic> dailyForecastWeather;

  const DetailPage({super.key, required this.dailyForecastWeather});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final Constants _constants = Constants();

  Map<String, dynamic> getForecastWeather(int index) {
    var weatherData = widget.dailyForecastWeather;
    int maxWindSpeed = weatherData[index]["day"]["maxwind_kph"].toInt();
    int avgHumidity = weatherData[index]["day"]["avghumidity"].toInt();
    int changeOfRain = weatherData[index]["day"]["daily_chance_of_rain"].toInt();

    var parsedDate = DateTime.parse(weatherData[index]["date"]);
    var forecastDate = DateFormat('EEEE d MMMM').format(parsedDate);

    String weatherName = weatherData[index]["day"]["condition"]["text"];
    String weatherIcon = "${weatherName.replaceAll(' ', '').toLowerCase()}.png";

    int minTemperature = weatherData[index]["day"]["mintemp_c"].toInt();
    int maxTemperature = weatherData[index]["day"]["maxtemp_c"].toInt();

    return {
      'minWindSpeed': maxWindSpeed,
      'avgHumidity': avgHumidity,
      'changeOfRain': changeOfRain,
      'forecastDate': forecastDate,
      'weatherName': weatherName,
      'weatherIcon': weatherIcon,
      'minTemperature': minTemperature,
      'maxTemperature': maxTemperature,
    };
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: _constants.primaryColor,
      appBar: AppBar(
        title: const Text('Forecast Detail'),
        centerTitle: true,
        backgroundColor: _constants.primaryColor,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: IconButton(
              onPressed: () {
                print("Settings Tapped!");
              },
              icon: const Icon(Icons.settings),
            ),
          ),
        ],
      ),
      body: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            child: Container(
              height: size.height * 0.7,
              width: size.width,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    top: -50,
                    left: 20,
                    right: 20,
                    child: Container(
                      height: 300,
                      width: size.width * 0.7,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.center,
                          colors: [
                            Color(0xffa9c1f5),
                            Color(0xff6696f5),
                          ],
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x1A0000FF),
                            offset: Offset(0, 25),
                            blurRadius: 3,
                            spreadRadius: -10,
                          ),
                        ],
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Positioned(
                            width: 150,
                            child: Image.asset(
                              'assets/' + getForecastWeather(0)["weatherIcon"],
                              fit: BoxFit.contain,
                            ),
                          ),
                          Positioned(
                              top: 155,
                              left: 25,
                              child: Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                      child: Text(getForecastWeather(0)["weatherName"],style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),),
                          ),),
                          Positioned(
                              bottom: 20,
                              left: 20,
                              child: Container(
                                width: size.width*0.8,
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  /*children: [
                                    WeatherItem(
                                      value: getForecastWeather(0)["maxWindSpeed"],
                                      unit: 'km/h',
                                      ImageUrl: "assets/windy.png",
                                    ),
                                    WeatherItem(
                                      value: getForecastWeather(0)["avgHumidity"],
                                      unit: '%',
                                      ImageUrl: "assets/humidity.png",
                                    ),WeatherItem(
                                      value: getForecastWeather(0)["changeOfRain"],
                                      unit: 'km/h',
                                      ImageUrl: "assets/light rain.png",
                                    ),
                                  ],*/ // hata aldığım yer
                                ),
                              ),),
                          Positioned(
                              top: 20,
                              right: 20,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(getForecastWeather(0)["maxTemperature"].toString(), style: TextStyle(
                                    fontSize: 80,
                                    fontWeight: FontWeight.bold,
                                    foreground: Paint()..shader=_constants.shader,
                                  ),),
                                  Text('°',style: TextStyle(
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold,
                                    foreground: Paint()..shader=_constants.shader,
                                  ),),
                                ],
                              ))
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
