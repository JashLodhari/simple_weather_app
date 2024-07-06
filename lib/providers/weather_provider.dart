import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_application/models/weather_model.dart';

class WeatherProvider with ChangeNotifier {
  Weather? _weather;
  Weather? get weather => _weather;

  String? _lastSearchedCity;
  String? get lastSearchedCity => _lastSearchedCity;

  Future<void> fetchWeather(String cityName) async {
    final apiKey = dotenv.env['OPENWEATHERMAP_API_KEY'];
    final url =
        'https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$apiKey&units=metric';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final weatherData = json.decode(response.body);
        _weather = Weather.fromJson(weatherData);
        _lastSearchedCity = cityName; // Save the city name
        await saveLastSearchedCity(); // Persist the city name
        notifyListeners();
      } else {
        throw Exception('Failed to load weather data');
      }
    } catch (error) {
      throw error;
    }
  }

  Future<void> loadLastSearchedCity() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _lastSearchedCity = prefs.getString('lastSearchedCity');
    if (_lastSearchedCity != null) {
      print('Loaded last searched city: $_lastSearchedCity');
      await fetchWeather(_lastSearchedCity!);
    } else {
      print('No last searched city found.');
    }
    notifyListeners();
  }

  Future<void> saveLastSearchedCity() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('lastSearchedCity', _lastSearchedCity!);
    print('Saved last searched city: $_lastSearchedCity');
  }
}
