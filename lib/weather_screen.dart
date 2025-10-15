import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
Future<Map<String,dynamic>> getCurrentWeather() async{
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
    return data;

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
              setState(() {
                getCurrentWeather();
              });;
            }, icon: const Icon(Icons.refresh),
            ),
          )
        ],
      ), 
      body: 
      FutureBuilder(
        future: getCurrentWeather(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting){
            return const Center( child: CircularProgressIndicator.adaptive());
          }
          if (snapshot.hasError){
            return Center(child: Text(snapshot.error.toString()));
          }
          final data = snapshot.data!;
   
          final currentWeatherData = data['list'][0]; // storing in variable

          final currentTemp = currentWeatherData['main']['temp'];
          final currentSky = currentWeatherData['weather'][0]['main'];
          final currentHumidity = currentWeatherData['main']['humidity'];
          final currentWindSpeed = currentWeatherData['wind']['speed'];
          final currentPressure = currentWeatherData['main']['pressure'];

          return Padding(
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
                              Text('$currentTemp K',
                              style: const TextStyle(
                                fontSize: 32, 
                                fontWeight: FontWeight.bold,
                              ),
                              ),
                              const SizedBox(height:16,),
                              Icon(currentSky == 'Rain' ? Icons.cloudy_snowing :currentSky == 'Clouds' 
                              ? Icons.cloud 
                              : Icons.sunny,
                              size: 64,
                              ),
                              const SizedBox(height:16,),
                               Text('$currentSky',
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
                const Text('Hourly forecast',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                ),
                const SizedBox(height: 10,),
                SizedBox(
                  height: 120,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 5,
                    itemBuilder: (context, index){
                  
                      final hourlyForecast = data['list'][index];
                      final hourlyTemp = data['list'][index]['main']['temp'].toString(); 
                      final hourlySky =  data['list'][index]['weather'][0]['main'];   

                      final time = DateTime.parse(hourlyForecast['dt_txt'].toString());
                      return HourlyForecastCard(
                        time: DateFormat.j().format(time), 
                        temperature: hourlyTemp ,
                        icon: hourlySky == 'Clouds' ? Icons.cloud : hourlySky == 'Rain' ? Icons.cloudy_snowing :Icons.sunny,
                        );
                    },
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    AdditionalInfoItem(
                      icon: Icons.water_drop,
                      label: 'Humidity',
                      value: '$currentHumidity',
                    ),
                    AdditionalInfoItem(
                      icon: Icons.air,
                      label: 'Wind Speed' ,
                      value: '$currentWindSpeed',
                    ),
                    AdditionalInfoItem(
                      icon: Icons.beach_access,
                      label: 'Pressure',
                      value: '$currentPressure',
                    ),
                  ],
                )
              ], 
            ),
          );
        }
      ),
    );
  }
}
