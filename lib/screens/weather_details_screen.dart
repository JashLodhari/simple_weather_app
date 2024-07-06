import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_application/providers/weather_provider.dart';

class WeatherDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final weatherProvider = Provider.of<WeatherProvider>(context);
    final weather = weatherProvider.weather;

    return Scaffold(
      appBar: AppBar(
        title: Text('Weather Details'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () async {
              try {
                await weatherProvider.fetchWeather(weatherProvider.lastSearchedCity!);
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to refresh weather data')),
                );
              }
            },
          ),
        ],
      ),
      body: weather == null
          ? Center(
        child: Text('No weather data available.'),
      )
          : Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.white, Colors.black],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'City: ${weather.cityName}',
                style: Theme.of(context).textTheme.headline4?.copyWith(color: Colors.black),
              ),
              SizedBox(height: 16),
              Center(
                child: Image.network(
                  'http://openweathermap.org/img/wn/${weather.iconCode}@2x.png',
                ),
              ),
              SizedBox(height: 16),
              _buildWeatherInfoContainer('Temperature: ${weather.temperature}°C', context),
              SizedBox(height: 8),
              _buildWeatherInfoContainer('Condition: ${weather.condition}', context),
              SizedBox(height: 8),
              _buildWeatherInfoContainer('Humidity: ${weather.humidity}%', context),
              SizedBox(height: 8),
              _buildWeatherInfoContainer('Wind Speed: ${weather.windSpeed} m/s', context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWeatherInfoContainer(String info, BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 4,
            offset: Offset(0, 2), // changes position of shadow
          ),
        ],
      ),
      child: Text(
        info,
        style: Theme.of(context).textTheme.bodyText1?.copyWith(color: Colors.white),
      ),
    );
  }
}
