import 'package:casher_mobile_app/services/services.dart';
import 'package:flutter/material.dart';

class ProductAutocomplete {
  int id;
  String name;
  ProductAutocomplete({required this.id, required this.name});
  // from map
  ProductAutocomplete.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        name = map['name'];
}

class AutocompleteServices extends Services {
  static final AutocompleteServices _instance =
      AutocompleteServices._internal();
  AutocompleteServices._internal() : super();
  factory AutocompleteServices.of(BuildContext context) {
    _instance.context = context;
    return _instance;
  }

  Future<List<ProductAutocomplete>> autoCompleteProductName(
      String productName) async {
    final data = await fetch().autoCompleteProductName(productName);
    if (data == null) return [];
    final List<ProductAutocomplete> productsList = [];
    for (final product in data['products']) {
      productsList.add(ProductAutocomplete.fromMap(product));
    }
    return productsList;
  }
}
