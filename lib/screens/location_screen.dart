import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utilities/constants.dart';
import '../services/weather.dart';
import 'city_screen.dart';

class LocationScreen extends StatefulWidget {
  LocationScreen({this.locationWeather});

  final locationWeather;

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  WeatherModel weather = WeatherModel();
  int temperature, humidity;
  String windSpeed, temperatureMin, temperatureMax;
  String weatherIcon;
  String cityName;
  String weatherMessage;
  String weatherDescription;

  @override
  void initState() {
    super.initState();

    updateUI(widget.locationWeather);
  }

  void updateUI(dynamic weatherData) {
    setState(() {
      if (weatherData == null) {
        temperature = 0;

        humidity = 0;
        windSpeed = '0';
        weatherIcon = 'Error';
        weatherMessage = 'Unable to get weather data';
        weatherDescription = 'Unable to get weather data';
        cityName = '';
        return;
      }
      double temp = weatherData['main']['temp'];

      humidity = weatherData['main']['humidity'];
      windSpeed = ((weatherData['wind']['speed']) * 3.6).toStringAsFixed(2);
      weatherDescription = weatherData['weather'][0]['description'];

      temperature = temp.toInt();

      var condition = weatherData['weather'][0]['id'];
      weatherIcon = weather.getWeatherIcon(condition);
      weatherMessage = weather.getMessage(temperature);
      cityName = weatherData['name'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/city1.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.8), BlendMode.dstATop),
          ),
        ),
        constraints: BoxConstraints.expand(),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  FlatButton(
                    onPressed: () async {
                      var weatherData = await weather.getLocationWeather();
                      updateUI(weatherData);
                    },
                    child: Icon(
                      Icons.near_me,
                      size: 50.0,
                    ),
                  ),
                  FlatButton(
                    onPressed: () async {
                      var typedName = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return CityScreen();
                          },
                        ),
                      );
                      if (typedName != null) {
                        var weatherData =
                            await weather.getCityWeather(typedName);
                        updateUI(weatherData);
                      }
                    },
                    child: Icon(
                      Icons.location_city,
                      size: 50.0,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Text(
                          "Wind Speed",
                          style: GoogleFonts.oswald(fontSize: 25),
                        ),
                        Text(
                          '$windSpeed Km/h',
                          style: GoogleFonts.oswald(fontSize: 25),
                        ),
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        Text(
                          "Humidity",
                          style: GoogleFonts.oswald(fontSize: 25),
                        ),
                        Text(
                          '$humidity %',
                          style: GoogleFonts.oswald(fontSize: 25),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Row(
                  children: <Widget>[
                    Center(
                      child: Text(
                        '$temperature°',
                        style: GoogleFonts.oswald(
                            fontWeight: FontWeight.bold, fontSize: 80),
                      ),
                    ),
                    Text(
                      weatherIcon,
                      style: kConditionTextStyle,
                    ),
                  ],
                ),
              ),
              Center(
                  child: Text(
                '$weatherDescription',
                style: GoogleFonts.oswald(
                    fontWeight: FontWeight.w500, fontSize: 30),
              )),
              Padding(
                padding: EdgeInsets.all(15.0),
                child: Text(
                  '$weatherMessage in $cityName',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.oswald(fontWeight: FontWeight.bold,fontSize: 60),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
