
import 'package:flutter_application_1/features/Fetching_Articles/data/Fetching_Articles_Web_Sers.dart';
import 'package:flutter_application_1/features/Fetching_Articles/domain/Fetching_Articles_Model.dart';


class ArticlesRepository {
  final NewsApiService service;

  ArticlesRepository(this.service);

  Future<List<Article>> getArticles() async {
    return await service.fetchArticles();
  }
}
