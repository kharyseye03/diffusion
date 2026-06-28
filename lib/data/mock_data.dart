import 'package:flutter/material.dart';
import '../models/channel.dart';

/// Données statiques pour la démo
class MockData {
  static const List<Channel> myChannels = [
    Channel(
      name: 'Dakar Phones Premium',
      owner: 'Vous',
      avatar: '📱',
      color: Color(0xFF0F3D33),
      subscribers: 248,
      isMine: true,
      articles: [
        Article(
          title: 'iPhone 15 Pro Max 256 Go',
          price: '785 000 FCFA',
          description: 'Neuf scellé · Titanium · Garantie 1 an',
          timeAgo: 'Il y a 2 h',
          icon: Icons.smartphone_rounded,
        ),
        Article(
          title: 'Samsung Galaxy S24 Ultra',
          price: '690 000 FCFA',
          description: 'Neuf · 512 Go · Noir',
          timeAgo: 'Il y a 5 h',
        ),
      ],
    ),
    Channel(
      name: 'Accessoires & Co',
      owner: 'Vous',
      avatar: '🎧',
      color: Color(0xFFA8862F),
      subscribers: 92,
      isMine: true,
      articles: [
        Article(
          title: 'AirPods Pro 2',
          price: '95 000 FCFA',
          description: 'Neuf · USB-C',
          timeAgo: 'Hier',
          icon: Icons.headphones_rounded,
        ),
      ],
    ),
  ];

  static const List<Channel> subscriptions = [
    Channel(
      name: 'Touba Electronics',
      owner: 'Modou Fall',
      avatar: '⚡',
      color: Color(0xFF1C5A4C),
      subscribers: 1240,
      isMine: false,
      unread: 2,
      articles: [
        Article(
          title: 'iPhone 14 — 128 Go',
          price: '520 000 FCFA',
          description: 'Comme neuf · Bleu · Batterie 96%',
          timeAgo: 'Il y a 20 min',
          imageUrl:
              'https://images.unsplash.com/photo-1678685888221-cda773a3dcdb?w=800&q=80',
        ),
      ],
    ),
    Channel(
      name: 'Sandaga Mobile',
      owner: 'Awa Diop',
      avatar: '🛍️',
      color: Color(0xFFB23B3B),
      subscribers: 530,
      isMine: false,
      articles: [
        Article(
          title: 'Xiaomi Redmi Note 13',
          price: '135 000 FCFA',
          description: 'Neuf · 256 Go · Vert',
          timeAgo: 'Il y a 1 h',
          imageUrl:
              'https://images.unsplash.com/photo-1610945265064-0e34e5519bbf?w=800&q=80',
        ),
      ],
    ),
    Channel(
      name: 'Pikine Tech Store',
      owner: 'Cheikh Ndiaye',
      avatar: '💎',
      color: Color(0xFF2E7D5B),
      subscribers: 318,
      isMine: false,
      unread: 1,
      articles: [
        Article(
          title: 'Google Pixel 8 Pro',
          price: '610 000 FCFA',
          description: 'Neuf scellé · Import US',
          timeAgo: 'Il y a 3 h',
          imageUrl:
              'https://images.unsplash.com/photo-1696446702183-cbd13d70e974?w=800&q=80',
        ),
      ],
    ),
  ];

  static const List<Invitation> invitations = [
    Invitation(
      channelName: 'Médina Gadgets',
      inviter: 'Fatou Sow',
      avatar: '🔌',
      color: Color(0xFF0F3D33),
      subscribers: 410,
      timeAgo: 'Il y a 10 min',
    ),
    Invitation(
      channelName: 'Liberté 6 Phones',
      inviter: 'Ibrahima Ba',
      avatar: '📲',
      color: Color(0xFFA8862F),
      subscribers: 156,
      timeAgo: 'Hier',
    ),
  ];

  /// Flux mélangé : dernières publications de tous les abonnements
  static List<({Channel channel, Article article})> get feed {
    final items = <({Channel channel, Article article})>[];
    for (final c in subscriptions) {
      for (final a in c.articles) {
        items.add((channel: c, article: a));
      }
    }
    return items;
  }
}
