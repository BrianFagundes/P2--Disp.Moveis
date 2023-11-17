import 'dart:convert';
import 'package:http/http.dart' as http;

class CatApi {
  final String baseUrl = 'https://api.thecatapi.com/v1/images/search';

  Future<List<String>> getCatPhotos() async {
    final response = await http.get(Uri.parse('$baseUrl?'), headers: {});

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((photo) => photo['url']).toList().cast<String>();
    } else {
      throw Exception('Falha ao obter fotos de gatos');
    }
  }
}
