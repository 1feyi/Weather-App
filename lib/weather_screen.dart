import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:weather_app/additional_info_item.dart';
import 'package:weather_app/hiddendetails.dart';
import 'package:weather_app/hourly_forecast_item.dart';
import 'package:http/http.dart' as http;

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  double temp = 0;
  @override
  void initState(){
    super.initState();
    getCurrentWeather();
  }
Future getCurrentWeather() async{
    try{
    String cityName = 'Abuja';
    final response = await http.get(
      Uri.parse(
        'https://api.openweathermap.org/data/2.5/forecast?q=$cityName,nigeria&APPID=$openWeatherAPIKey',
      ),
    );
    final data = jsonDecode(response.body);
    if (data ['cod'] != '200'){
      throw 'An unexpected error occured';
    }
    setState(() {
      temp = data ['list'][0]['main']['temp'];
    });

    }catch(e){
      throw e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather App',
        style: TextStyle(
         fontWeight: FontWeight.bold,
         fontSize: 20,
        ),
        ), 
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: IconButton(
              onPressed: (){
              print('refresh');
            }, icon: const Icon(Icons.refresh),
            ),
          )
        ],
      ), 
      body: temp == 0 ? const CircularProgressIndicator():
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start ,
          children: [
            //main card 
            SizedBox(
              width: double.infinity,
              child: Card(
                color: const Color.fromARGB(255, 65, 75, 88),
                elevation: 15,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: 10,
                      sigmaY: 10,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text('$temp K',
                          style: const TextStyle(
                            fontSize: 32, 
                            fontWeight: FontWeight.bold,
                          ),
                          ),
                          const SizedBox(height:16,),
                          const Icon(Icons.cloud,
                          size: 64,
                          ),
                          const SizedBox(height:16,),
                          const Text('Rain',
                          style: TextStyle(
                            fontSize: 20,
                          ),
                          ),
                        ],
                      ),
                    ), 
                  ),
                ),
              ),
            ),
            //weather forecast cards 
            const SizedBox(height: 20,),
            const Text('Weather forecast',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            ),
            const SizedBox(height: 10,),
            const SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  HourlyForecastCard(
                    time: '09:00',
                    temperature: '301.17',
                    icon: Icons.cloud,
                  ),
                  HourlyForecastCard(
                    time: '12:00',
                    temperature: '301.54',
                    icon: Icons.sunny,
                  ),
                  HourlyForecastCard(
                    time: '15:00',
                    temperature: '301.11',
                    icon: Icons.sunny,
                  ),
                  HourlyForecastCard(
                    time: '18:00',
                    temperature: '300.75',
                    icon: Icons.cloud,
                  ),
                  HourlyForecastCard(
                    time: '19:00',
                    temperature: '300.95',
                    icon: Icons.cloud,
                  ),
                ],
              ),
            ),
            // Additional information 
            const SizedBox(height: 20,),
             const Text('Additional Information',
             style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            ), 

            const SizedBox(height: 10,),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                AdditionalInfoItem(
                  icon: Icons.water_drop,
                  label: 'Humidity',
                  value: '91',
                ),
                AdditionalInfoItem(
                  icon: Icons.air,
                  label: 'Wind Speed' ,
                  value: '7.5',
                ),
                AdditionalInfoItem(
                  icon: Icons.beach_access,
                  label: 'Pressure',
                  value: '1000',
                ),
              ],
            )
          ], 
        ),
      ),
    );
  }
}
