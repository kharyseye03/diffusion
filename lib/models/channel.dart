import 'package:flutter/material.dart';

/// Article (téléphone) publié dans un canal
class Article {
  final String title;
  final String price;
  final String description;
  final IconData icon;
  final String timeAgo;
  final String? imageUrl;

  const Article({
    required this.title,
    required this.price,
    required this.description,
    required this.timeAgo,
    this.icon = Icons.smartphone_rounded,
    this.imageUrl,
  });
}

/// Canal de diffusion
class Channel {
  final String name;
  final String owner;
  final String avatar; // emoji ou initiale
  final Color color;
  final int subscribers;
  final bool isMine; // true = je suis le diffuseur
  final List<Article> articles;
  final int unread; // diffusions reçues non lues (côté abonné)

  const Channel({
    required this.name,
    required this.owner,
    required this.avatar,
    required this.color,
    required this.subscribers,
    required this.isMine,
    required this.articles,
    this.unread = 0,
  });

  Article? get lastArticle => articles.isEmpty ? null : articles.first;
}

/// Invitation reçue à rejoindre un canal
class Invitation {
  final String channelName;
  final String inviter;
  final String avatar;
  final Color color;
  final int subscribers;
  final String timeAgo;

  const Invitation({
    required this.channelName,
    required this.inviter,
    required this.avatar,
    required this.color,
    required this.subscribers,
    required this.timeAgo,
  });
}
