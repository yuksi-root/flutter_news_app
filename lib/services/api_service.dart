import 'package:dio/dio.dart';
import 'package:flutter_news_app_with_api/constants/api_constants.dart';
import 'package:flutter_news_app_with_api/models/news_article.dart';

class ApiService {
  late Dio _dio; //= new Dio();

  ApiService() {
    _dio = Dio();
  }

  Future<List<NewsArticle>> fetchHeadlinesByCountry(String country) async {
    final response = await _dio.get(ApiConstants.headlinesFor(country));

    if (response.statusCode == 200) {
      final result = response.data;
      Iterable list = result['articles'];
      return list.map((article) => NewsArticle.fromJson(article)).toList();
    } else {
      throw Exception("Failed to get top news with country");
    }
  }

  Future<List<NewsArticle>> fetchTopHeadlines() async {
    final response = await _dio.get(ApiConstants.defaultTopHeadlinesUrl);

    if (response.statusCode == 200) {
      final result = response.data;
      Iterable list = result['articles'];
      return list.map((article) => NewsArticle.fromJson(article)).toList();
    } else {
      throw Exception("Failed to get top news with default country");
    }
  }
}
