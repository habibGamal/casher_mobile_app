import 'package:casher_mobile_app/services/services.dart';
import 'package:flutter/material.dart';

class StockItem {
  final String stockName;
  final double quantity;
  StockItem({
    required this.stockName,
    required this.quantity,
  });
  factory StockItem.fromMap(Map<String, dynamic> map) {
    return StockItem(
      stockName: map['stock_name'],
      quantity: double.parse(map['quantity'].toString()),
    );
  }
}

class StocksServices extends Services {
  StocksServices._internal() : super();
  static final StocksServices _instance = StocksServices._internal();
  factory StocksServices.of(BuildContext context) {
    _instance.context = context;
    return _instance;
  }

  Future<List<StockItem>> productInfoFromAllStocks(int productId) async {
    final data = await fetch().productInfoFromAllStocks(productId);
    if (data == null) return [];
    final List<StockItem> stockItemsList = [];
    for (final stockItem in data['stockItems']) {
      stockItemsList.add(StockItem.fromMap(stockItem));
    }
    return stockItemsList;
  }
}
