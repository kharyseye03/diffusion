class Product {
  final String id;
  final String name;
  final String brand;
  final double price;
  final int stock;
  final String description;
  final String imageUrl;
  final bool isNew;

  const Product({
    required this.id,
    required this.name,
    required this.brand,
    required this.price,
    required this.stock,
    required this.description,
    required this.imageUrl,
    this.isNew = false,
  });
}

final List<Product> demoProducts = [
  const Product(
    id: '1',
    name: 'iPhone 15 Pro',
    brand: 'Apple',
    price: 520000,
    stock: 12,
    description: 'iPhone 15 Pro avec puce A17 Pro, écran Super Retina XDR 6.1", caméra 48MP, titane.',
    imageUrl: 'https://images.unsplash.com/photo-1695048133142-1a20484d2569?w=400',
    isNew: true,
  ),
  const Product(
    id: '2',
    name: 'Samsung Galaxy S24 Ultra',
    brand: 'Samsung',
    price: 480000,
    stock: 8,
    description: 'Galaxy S24 Ultra avec S Pen intégré, écran Dynamic AMOLED 6.8", caméra 200MP.',
    imageUrl: 'https://images.unsplash.com/photo-1706606011440-bc0a41bebf83?w=400',
    isNew: true,
  ),
  const Product(
    id: '3',
    name: 'Xiaomi 14 Pro',
    brand: 'Xiaomi',
    price: 290000,
    stock: 25,
    description: 'Xiaomi 14 Pro avec Snapdragon 8 Gen 3, caméra Leica, charge rapide 120W.',
    imageUrl: 'https://images.unsplash.com/photo-1598327105666-5b89351aff97?w=400',
  ),
  const Product(
    id: '4',
    name: 'Tecno Spark 20 Pro',
    brand: 'Tecno',
    price: 85000,
    stock: 50,
    description: 'Tecno Spark 20 Pro, écran 6.78" FHD+, batterie 5000mAh, charge 18W.',
    imageUrl: 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=400',
  ),
  const Product(
    id: '5',
    name: 'Infinix Hot 40 Pro',
    brand: 'Infinix',
    price: 75000,
    stock: 35,
    description: 'Infinix Hot 40 Pro, Helio G99, 8Go RAM, 256Go, batterie 5000mAh.',
    imageUrl: 'https://images.unsplash.com/photo-1592899677977-9c10ca588bbd?w=400',
  ),
  const Product(
    id: '6',
    name: 'ITEL A70',
    brand: 'ITEL',
    price: 35000,
    stock: 100,
    description: 'ITEL A70, entrée de gamme abordable, écran 6.6", batterie 5000mAh.',
    imageUrl: 'https://images.unsplash.com/photo-1512941937669-90a1b58e7e9c?w=400',
  ),
];
