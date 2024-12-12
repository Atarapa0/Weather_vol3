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

    print('Toplam hava durumu verisi: ${weatherData.length}');

    if (weatherData == null || weatherData.isEmpty) {
      print('Hava durumu verisi boş');
      return {
        'minWindSpeed': 0,
        'avgHumidity': 0,
        'changeOfRain': 0,
        'forecastDate': 'No Date',
        'weatherName': 'No Data',
        'weatherIcon': 'default.png',
        'minTemperature': 0,
        'maxTemperature': 0,
      };
    }

    if (index < 0 || index >= weatherData.length) {
      print('İstenen indeks mevcut değil: $index');
      index = 0;
    }

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
                              child: Text(
                                getForecastWeather(0)["weatherName"],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 20,
                            left: 20,
                            child: Container(
                              width: size.width * 0.8,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  if (getForecastWeather(0)["minWindSpeed"] != null)
                                    WeatherItem(
                                      value: getForecastWeather(0)["minWindSpeed"],
                                      unit: 'km/h',
                                      ImageUrl: "assets/windy.png",
                                    ),
                                  if (getForecastWeather(0)["avgHumidity"] != null)
                                    WeatherItem(
                                      value: getForecastWeather(0)["avgHumidity"],
                                      unit: '%',
                                      ImageUrl: "assets/humidity.png",
                                    ),
                                  if (getForecastWeather(0)["changeOfRain"] != null)
                                    WeatherItem(
                                      value: getForecastWeather(0)["changeOfRain"],
                                      unit: '%',
                                      ImageUrl: "assets/light rain.png",
                                    ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            top: 20,
                            right: 20,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  getForecastWeather(0)["maxTemperature"]
                                      .toString(),
                                  style: TextStyle(
                                    fontSize: 80,
                                    fontWeight: FontWeight.bold,
                                    foreground: Paint()
                                      ..shader = _constants.shader,
                                  ),
                                ),
                                Text(
                                  '°',
                                  style: TextStyle(
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold,
                                    foreground: Paint()
                                      ..shader = _constants.shader,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            top: 320,
                            left: 4,
                            child: SizedBox(
                              height: 400,
                              width: size.width * 0.9,
                              child: ListView(
                                physics: const BouncingScrollPhysics(),
                                children: [
                                  Card(
                                    elevation: 3,
                                    margin: const EdgeInsets.only(bottom: 20),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                getForecastWeather(
                                                    0)["forecastDate"],
                                                style: const TextStyle(
                                                  color: Color(0xff6696f5),
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text(
                                                        getForecastWeather(0)[
                                                                "minTemperature"]
                                                            .toString(),
                                                        style: TextStyle(
                                                          color: _constants
                                                              .greyColor,
                                                          fontSize: 30,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                      Text(
                                                        '°',
                                                        style: TextStyle(
                                                          color: _constants
                                                              .greyColor,
                                                          fontSize: 25,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontFeatures: const [
                                                            FontFeature.enable(
                                                                'sups'),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        getForecastWeather(0)[
                                                                "maxTemperature"]
                                                            .toString(),
                                                        style: TextStyle(
                                                          color: _constants
                                                              .blackColor,
                                                          fontSize: 30,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                      Text(
                                                        '°',
                                                        style: TextStyle(
                                                          color: _constants
                                                              .blackColor,
                                                          fontSize: 25,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontFeatures: const [
                                                            FontFeature.enable(
                                                                'sups'),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Image.asset(
                                                    'assets/' +
                                                        getForecastWeather(
                                                            0)["weatherIcon"],
                                                    width: 30,
                                                  ),
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                    getForecastWeather(
                                                        0)["weatherName"],
                                                    style: const TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    getForecastWeather(
                                                        0)["changeOfRain"].toString() + "%",
                                                    style: const TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  Image.asset(
                                                    'assets/light rain.png',
                                                    width: 30,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Card(
                                    elevation: 3,
                                    margin: const EdgeInsets.only(bottom: 20),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                getForecastWeather(
                                                    1)["forecastDate"],
                                                style: const TextStyle(
                                                  color: Color(0xff6696f5),
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text(
                                                        getForecastWeather(1)[
                                                        "minTemperature"]
                                                            .toString(),
                                                        style: TextStyle(
                                                          color: _constants
                                                              .greyColor,
                                                          fontSize: 30,
                                                          fontWeight:
                                                          FontWeight.w600,
                                                        ),
                                                      ),
                                                      Text(
                                                        '°',
                                                        style: TextStyle(
                                                          color: _constants
                                                              .greyColor,
                                                          fontSize: 25,
                                                          fontWeight:
                                                          FontWeight.w600,
                                                          fontFeatures: const [
                                                            FontFeature.enable(
                                                                'sups'),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        getForecastWeather(1)[
                                                        "maxTemperature"]
                                                            .toString(),
                                                        style: TextStyle(
                                                          color: _constants
                                                              .blackColor,
                                                          fontSize: 30,
                                                          fontWeight:
                                                          FontWeight.w600,
                                                        ),
                                                      ),
                                                      Text(
                                                        '°',
                                                        style: TextStyle(
                                                          color: _constants
                                                              .blackColor,
                                                          fontSize: 25,
                                                          fontWeight:
                                                          FontWeight.w600,
                                                          fontFeatures: const [
                                                            FontFeature.enable(
                                                                'sups'),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.center,
                                                children: [
                                                  Image.asset(
                                                    'assets/' +
                                                        getForecastWeather(
                                                            1)["weatherIcon"],
                                                    width: 30,
                                                  ),
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                    getForecastWeather(
                                                        1)["weatherName"],
                                                    style: const TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    getForecastWeather(
                                                        1)["changeOfRain"].toString() + "%",
                                                    style: const TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  Image.asset(
                                                    'assets/light rain.png',
                                                    width: 30,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Card(
                                    elevation: 3,
                                    margin: const EdgeInsets.only(bottom: 20),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                getForecastWeather(
                                                    0)["forecastDate"],
                                                style: const TextStyle(
                                                  color: Color(0xff6696f5),
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text(
                                                        getForecastWeather(0)[
                                                        "minTemperature"]
                                                            .toString(),
                                                        style: TextStyle(
                                                          color: _constants
                                                              .greyColor,
                                                          fontSize: 30,
                                                          fontWeight:
                                                          FontWeight.w600,
                                                        ),
                                                      ),
                                                      Text(
                                                        '°',
                                                        style: TextStyle(
                                                          color: _constants
                                                              .greyColor,
                                                          fontSize: 25,
                                                          fontWeight:
                                                          FontWeight.w600,
                                                          fontFeatures: const [
                                                            FontFeature.enable(
                                                                'sups'),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        getForecastWeather(0)[
                                                        "maxTemperature"]
                                                            .toString(),
                                                        style: TextStyle(
                                                          color: _constants
                                                              .blackColor,
                                                          fontSize: 30,
                                                          fontWeight:
                                                          FontWeight.w600,
                                                        ),
                                                      ),
                                                      Text(
                                                        '°',
                                                        style: TextStyle(
                                                          color: _constants
                                                              .blackColor,
                                                          fontSize: 25,
                                                          fontWeight:
                                                          FontWeight.w600,
                                                          fontFeatures: const [
                                                            FontFeature.enable(
                                                                'sups'),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.center,
                                                children: [
                                                  Image.asset(
                                                    'assets/' +
                                                        getForecastWeather(
                                                            0)["weatherIcon"],
                                                    width: 30,
                                                  ),
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                    getForecastWeather(
                                                        0)["weatherName"],
                                                    style: const TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    getForecastWeather(
                                                        0)["changeOfRain"].toString() + "%",
                                                    style: const TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  Image.asset(
                                                    'assets/light rain.png',
                                                    width: 30,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          )
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
