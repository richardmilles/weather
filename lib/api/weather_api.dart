import 'package:http/http.dart' as http;
import 'dart:convert';

class WeatherAPI {
  final String apiKey = '31426e751ea8cbac65666783651e7eda'; // Remplacez YOUR_API_KEY par votre clé d'API

  Future<Map<String, dynamic>> fetchWeatherData(String cityName) async {
    final url = 'https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$apiKey';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data;
    } else {
      throw Exception('Failed to fetch weather data');
    }
  }
}
