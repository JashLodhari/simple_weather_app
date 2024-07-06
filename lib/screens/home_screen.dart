import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_application/providers/weather_provider.dart';
import 'package:weather_application/screens/weather_details_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  bool _isLoading = false;
  String _error = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadLastSearchedCity();
    });
  }

  Future<void> _loadLastSearchedCity() async {
    try {
      await Provider.of<WeatherProvider>(context, listen: false).loadLastSearchedCity();
      final lastSearchedCity = Provider.of<WeatherProvider>(context, listen: false).lastSearchedCity;
      if (lastSearchedCity != null) {
        setState(() {
          _controller.text = lastSearchedCity;
        });
      }
    } catch (error) {
      // Handle error if needed
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather App'),
      ),
      body: Container(
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
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _controller,
                decoration: InputDecoration(
                  labelText: 'Enter City Name',
                  labelStyle: TextStyle(color: Colors.black),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.1),
                ),
                style: TextStyle(color: Colors.black),
              ),
              SizedBox(height: 16),
              ElevatedButton(

                onPressed: () async {
                  if (_controller.text.isEmpty) {
                    setState(() {
                      _error = 'Please enter a city name';
                    });
                    return;
                  }

                  setState(() {
                    _isLoading = true;
                    _error = '';
                  });

                  try {
                    await Provider.of<WeatherProvider>(context, listen: false)
                        .fetchWeather(_controller.text);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WeatherDetailsScreen(),
                      ),
                    );
                  } catch (e) {
                    setState(() {
                      _error = 'Failed to load weather data';
                    });
                  } finally {
                    setState(() {
                      _isLoading = false;
                    });
                  }
                },
                child: Text('Get Weather'),
              ),
              SizedBox(height: 16),
              if (_isLoading)
                Center(child: CircularProgressIndicator())
              else if (_error.isNotEmpty)
                Center(
                  child: Text(
                    _error,
                    style: TextStyle(color: Colors.red, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _searchWeather() async {
    setState(() {
      _isLoading = true;
      _error = '';
    });

    try {
      await Provider.of<WeatherProvider>(context, listen: false)
          .fetchWeather(_controller.text);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WeatherDetailsScreen(),
        ),
      );
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
