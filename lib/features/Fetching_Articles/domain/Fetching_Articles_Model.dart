import 'package:flutter/material.dart';

class Article {
  Article({
    required this.title,
    required this.link,
    required this.date,
    required this.content,
    required this.image,
    
  });

  final String title;
  final String link;
  final String date;
  final String content;
   final String image;

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'],
      link: json['url'],
      date: json['publishedAt'],
      content: json['description'],
      image: json['image'],
    );
  }
}

List<Article> articleslist = [];
