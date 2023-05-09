import 'package:flutter/material.dart';

class Weather extends StatefulWidget {
  const Weather({super.key});

  @override
  State<Weather> createState() => _WeatherState();
}

class WeatherData {
  String? temperature;
  String? date;
  String? wind;
  WeatherData(this.temperature, this.date, this.wind);
}

class _WeatherState extends State<Weather> {
  List<WeatherData> weather_data = [
    WeatherData("19°C", "Today", "5m/s"),
    WeatherData("20°C", "Tomorrow", "8m/s"),
    WeatherData("25°C", "11.05.23", "6m/s"),
    WeatherData("25°C", "12.05.23", "4m/s"),
    WeatherData("26°C", "13.05.23", "2m/s"),
    WeatherData("30°C", "14.05.23", "6m/s"),
    WeatherData("21°C", "15.05.23", "5m/s"),
  ];
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
              height: 20,
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Weather",
                  style: TextStyle(
                      fontSize: 40, fontFamily: 'Poppins', color: Colors.white),
                )
              ],
            ),
            const SizedBox(height: 40),
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
            const Padding(
              padding: EdgeInsets.fromLTRB(30, 10, 50, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
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
                      Text(
                        "15°C",
                        style: TextStyle(
                            fontSize: 30,
                            fontFamily: 'JoseficSans',
                            color: Colors.white),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        '24°C',
                        style: TextStyle(
                            fontSize: 30,
                            fontFamily: 'JoseficSans',
                            color: Colors.white),
                      )
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
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: weather_data.length,
                    itemBuilder: (context, index) {
                      return Padding(
                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: Container(
                            child: Column(
                              children: [
                                Container(
                                  constraints: const BoxConstraints(
                                    minWidth: 100
                                  ),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: weather_data[index].date ==
                                                'Today'
                                            ? const Color.fromRGBO(244, 244, 244, 1)
                                            : const Color.fromRGBO(
                                                255, 255, 255, 0.4)),
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(15, 5, 15, 5),
                                      child: Text(
                                        '${weather_data[index].date}',
                                        style: const TextStyle(
                                            fontSize: 20,
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )),
                                    
                                Container(
                                  margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                                  constraints: const BoxConstraints(
                                    minWidth: 100
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: const Color.fromRGBO(244, 244, 244, 0.4), width: 5)
                                  ),
                                    child: Padding(
                                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  child: Column(
                                    children: [
                                      Text('${weather_data[index].temperature}', style: const TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 20
                                      ),),
                                      const SizedBox(height: 15),
                                      const Icon(Icons.sunny, size: 40),
                                      const SizedBox(height: 10),
                                      Text("${weather_data[index].wind}",style: const TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 20
                              
                                      ),),
                                      const SizedBox(height: 5),
                                    ],
                                  ),
                                ))
                              ],
                            ),
                          ));
                    },
                  )),
            )
          ],
        ),
      ),
    );
  }
}
