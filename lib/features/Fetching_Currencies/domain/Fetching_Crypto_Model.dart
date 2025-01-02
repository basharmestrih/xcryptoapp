class CryptoPrices {
  final String name;
  final String id;
  final String symbol;
  final String imageUrl;
  final double price;
  final double changePercentage;
  final double high_24h;
  final double low_24h;
  final int market_cap_rank;

  CryptoPrices({
    required this.name,
    required this.id,
    required this.symbol,
    required this.imageUrl,
    required this.price,
    required this.changePercentage,
    required this.high_24h,
    required this.low_24h,
    required this.market_cap_rank,
  });

  // Factory constructor to create a Coin from JSON (API response)
  factory CryptoPrices.fromJson(Map<String, dynamic> json) {
    return CryptoPrices(
      name: json['name'],
      id: json['id'],
      symbol: json['symbol'],
      imageUrl: json['image'],
      price: json['current_price'].toDouble(),
      changePercentage: json['price_change_percentage_24h'].toDouble(),
      high_24h: json['high_24h'].toDouble(),
      low_24h: json['low_24h'].toDouble(),
      market_cap_rank: json['market_cap_rank'],
    );
  }
}