// States for ArticlesCubit
import 'package:flutter_application_1/features/Fetching_Articles/domain/Fetching_Articles_Model.dart';

abstract class ArticlesState {}

class ArticlesInitial extends ArticlesState {}

class ArticlesLoading extends ArticlesState {}

class ArticlesLoaded extends ArticlesState {
  final List<Article> articles;

  ArticlesLoaded(this.articles);
}

class ArticlesError extends ArticlesState {
  final String message;

  ArticlesError(this.message);
}

class ArticlesFiltered extends ArticlesState {
  final List<Article> filteredArticles;

  ArticlesFiltered(this.filteredArticles);
}
