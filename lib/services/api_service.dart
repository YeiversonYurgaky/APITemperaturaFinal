import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static Future<double?> getTemperature(
      double latitude, double longitude) async {
    try {
      final url = Uri.parse(
          'https://api.open-meteo.com/v1/forecast?latitude=$latitude&longitude=$longitude&current_weather=true');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['current_weather']['temperature'];
      } else {
        return null;
      }
    } catch (e) {
      print('Error fetching temperature: $e');
      return null;
    }
  }
}
