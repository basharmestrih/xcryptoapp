import 'package:flutter_application_1/features/Fetching_Articles/application/Fetching_Articles_State.dart';
import 'package:flutter_application_1/features/Fetching_Articles/data/Fetching_Articles_Repo.dart';
import 'package:flutter_application_1/features/Fetching_Articles/domain/Fetching_Articles_Model.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class ArticlesCubit extends Cubit<ArticlesState> {
  final ArticlesRepository repository;

  List<Article> _allArticles = []; // Keep all data here for filtering purposes

  ArticlesCubit(this.repository) : super(ArticlesLoading());

  Future<void> fetchoArticles() async {
    try {
      final articles = await repository.getArticles();
      _allArticles = articles; // Store the full data list
      emit(ArticlesLoaded(_allArticles));
    } catch (e) {
      print(e);
      emit(ArticlesError('Failed to fetch data'));
    }
  }
}
