import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:examflu/api/weather_api.dart';

class ProgressScreen extends StatefulWidget {
  @override
  _ProgressScreenState createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  double progress = 0.0;
  List<String> messages = [
    'Nous téléchargeons les données...',
    'C\'est presque fini...',
    'Plus que quelques secondes avant d\'avoir le résultat...'
  ];
  int currentMessageIndex = 0;
  late Timer timer;
  WeatherAPI weatherAPI = WeatherAPI();
  List<Map<String, dynamic>> weatherResults = [];

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(seconds: 6), (timer) {
      setState(() {
        currentMessageIndex = (currentMessageIndex + 1) % messages.length;
      });
    });
    startProgress();
  }

  void startProgress() {
    Timer.periodic(Duration(seconds: 10), (timer) {
      if (progress >= 1.0) {
        timer.cancel();
        fetchWeatherDataForCities(); // Appel à l'API pour toutes les villes après que la jauge soit remplie
      } else {
        setState(() {
          progress += 0.1;
        });
      }
    });
  }

  Future<void> fetchWeatherDataForCities() async {
    List<String> cities = ['Rennes', 'Paris', 'Nantes', 'Bordeaux', 'Lyon'];

    for (String city in cities) {
      final data = await weatherAPI.fetchWeatherData(city);
      setState(() {
        weatherResults.add(data);
      });
    }
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (progress >= 1.0) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Résultats'),
        ),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Résultats obtenus',
                style: TextStyle(fontSize: 24),
              ),
              SizedBox(height: 16.0),
              Table(
                border: TableBorder.all(),
                columnWidths: const {
                  0: FlexColumnWidth(1),
                  1: FlexColumnWidth(1),
                  2: FlexColumnWidth(1),
                },
                children: List.generate(weatherResults.length, (index) {
                  final result = weatherResults[index];
                  final cityName = result['name'];
                  final temperature = result['main']['temp'];
                  final cloudiness = result['weather'][0]['description'];

                  return TableRow(
                    children: [
                      TableCell(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(cityName),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Température: ${temperature.toString()}'),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Couverture nuageuse: $cloudiness'),
                        ),
                      ),
                    ],
                  );
                }),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                child: Text('Recommencer'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text('Progression'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                messages[currentMessageIndex],
                style: TextStyle(fontSize: 24),
              ),
              SizedBox(height: 20),
              Container(
                height: 10,
                width: MediaQuery.of(context).size.width * 0.8,
                decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).colorScheme.secondary),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: FractionallySizedBox(
                  widthFactor: progress,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Progression: ${(progress * 100).toStringAsFixed(1)}%',
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
      );
    }
  }
}
