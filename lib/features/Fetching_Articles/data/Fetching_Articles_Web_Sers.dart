import 'dart:convert';

import 'package:flutter_application_1/features/Fetching_Articles/domain/Fetching_Articles_Model.dart';import 'package:http/http.dart' as http;
class NewsApiService {
  Future<List<Article>> fetchArticles() async {
    final response = await http.get(Uri.parse('https://gnews.io/api/v4/top-headlines?category=general&q=bitcoin&lang=en&country=us&apikey=25f024f83ed31c166a835bec63298df7'));

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final List<dynamic> jsonList = jsonResponse['articles'];
      // Map each item in the JSON list to an Article object
      return jsonList.map((json) => Article.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load articles');
    }
  }
}
