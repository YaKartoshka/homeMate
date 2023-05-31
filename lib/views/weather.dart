import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
class Weather extends StatefulWidget {
  const Weather({super.key});

  @override
  State<Weather> createState() => _WeatherState();
}

class WeatherData {
  String? title;
  
  WeatherData(this.title);
}

class WeatherService {
  final String apiKey = '9d871ad2b9208dc3684541b72083256e';
  var headers = {'Content-Type': 'application/json'};
  Future<dynamic> getWeatherData(String city) async {
    final uri = Uri.parse('https://api.openweathermap.org/data/2.5/weather?q=${city}&appid=${apiKey}&units=metric');
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch weather data');
    }
  }
}

class _WeatherState extends State<Weather> {
    WeatherService _weatherService = WeatherService();
  dynamic _weatherData;
  
  String _selectedCity = 'Astana'; // Set a default city
  List<WeatherData> weather_data = [
     WeatherData('Temperature'),
    WeatherData("Wind"),
    WeatherData("Humidity"),
    WeatherData("Sky"),
    WeatherData("Clouds"),
   
  ];
Future<void> _fetchWeatherData(String city) async {
    try {
      var weatherData = await _weatherService.getWeatherData(city);
      setState(() {
        _weatherData = weatherData;
  
      });
    } catch (e) {
      print('Error fetching weather data: $e');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchWeatherData(_selectedCity);
    
  }

  @override
  Widget build(BuildContext context) {
    final adaptive_size = MediaQuery.of(context).size;
   
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(MediaQuery.of(context).padding.top),
        child: SizedBox(
          height: MediaQuery.of(context).padding.top,
        ),
      ),
      body: Container(
        height: adaptive_size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/background.png"),
              fit: BoxFit.fill,
              colorFilter: ColorFilter.mode(
                  Color.fromARGB(255, 149, 152, 229), BlendMode.overlay)),
        ),
        child: Column(
          children: [
            const SizedBox(
              height: 15,
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Weather",
                  style: TextStyle(
                      fontSize: 30, fontFamily: 'Poppins', color: Colors.white, fontWeight: FontWeight.w500),
                )
              ],
            ),
            const SizedBox(height: 30),
            const Padding(
              padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
              child: Row(children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                      child: Text(
                        "KZ,",
                        style: TextStyle(
                            fontSize: 50,
                            fontFamily: 'JoseficSans',
                            color: Colors.white),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(0),
                      child: Text(
                        "Astana",
                        style: TextStyle(
                            fontSize: 50,
                            fontFamily: 'JoseficSans',
                            color: Colors.white),
                      ),
                    )
                  ],
                )
              ]),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 10, 50, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Min",
                        style: TextStyle(
                            fontSize: 30,
                            fontFamily: 'JoseficSans',
                            color: Colors.white),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        'Max',
                        style: TextStyle(
                            fontSize: 30,
                            fontFamily: 'JoseficSans',
                            color: Colors.white),
                      )
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _weatherData != null ?
                      Text(
                        '${_weatherData['main']['temp_min']}°C',
                        style: const TextStyle(
                            fontSize: 30,
                            fontFamily: 'JoseficSans',
                            color: Colors.white),
                      ) : const CircularProgressIndicator(),
                      const SizedBox(
                        height: 15,
                      ),
                      _weatherData != null ?
                      Text(
                        '${_weatherData['main']['temp_max']}°C',
                        style: const TextStyle(
                            fontSize: 30,
                            fontFamily: 'JoseficSans',
                            color: Colors.white),
                      ) : const CircularProgressIndicator(),
                    ],
                  )
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(30, 0, 30, 0),
              height: adaptive_size.height / 3,
              decoration: BoxDecoration(
                  color: const Color.fromRGBO(244, 244, 244, 0.4),
                  borderRadius: BorderRadius.circular(30)),
              child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: 
                  _weatherData != null ?
                   ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      
                       var temperature = _weatherData['main']['temp'].toString();
                       var wind=_weatherData['wind']['speed'].toString();
                       var humidity = _weatherData['main']['humidity'].toString();
                       var sky = _weatherData['weather'][0]['main'].toString();
                       var clouds = _weatherData['clouds']['all'].toString();
                        var weather_array=[
                          '$temperature°C', '${wind}m/s', humidity, sky, '${clouds}%'
                        ];
                        
                      return Padding(
                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: Container(
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                    constraints:
                                        const BoxConstraints(minWidth: 100),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: weather_data[index].title ==
                                                'Today'
                                            ? const Color.fromRGBO(
                                                244, 244, 244, 1)
                                            : const Color.fromRGBO(
                                                255, 255, 255, 0.4)),
                                    child: Center(
                                     heightFactor: 1.4,
                                      child: Text(
                                        '${weather_data[index].title}',
                                        style: const TextStyle(
                                            fontSize: 20,
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w600),
                                      ),
                                    )),
                                Container(
                                    margin:
                                        const EdgeInsets.fromLTRB(0, 20, 0, 0),
                                    constraints:
                                        const BoxConstraints(minWidth: 100),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                            color: const Color.fromRGBO(
                                                244, 244, 244, 0.4),
                                            width: 5)),
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                      child: Column(
                                        children: [
                                        
                                          const SizedBox(height: 15),
                                          const Icon(Icons.sunny, size: 40),
                                          const SizedBox(height: 10),
                                          Text(
                                            '${weather_array[index]}',
                                            style: const TextStyle(
                                                fontFamily: 'Poppins',
                                                fontSize: 20),
                                          ),
                                          const SizedBox(height: 5),
                                        ],
                                      ),
                                    ))
                              ],
                            ),
                          ));
                    },
                  ) : const Center(
                        child: CircularProgressIndicator(),
                      ),
                  
                  ),
            )
          ],
        ),
      ),
    );
  }
}
