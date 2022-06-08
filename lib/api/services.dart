import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'model.dart';

class services {
  static fetchAlbum() async {
    var now = DateTime.now();
    var formatter = DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(now);
    // print(formattedDate);
    final response = await http.get(Uri.parse(
        'https://newsapi.org/v2/everything?q=indian&from=$formattedDate&to=$formattedDate&sortBy=popularity&apiKey=81f2268c6569466ea5cee2d9f401cce8'));
    // print(response);
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return Welcome.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }
}
