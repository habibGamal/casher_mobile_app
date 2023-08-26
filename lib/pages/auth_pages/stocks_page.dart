import 'package:casher_mobile_app/graphql/queries.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class StockItem {
  final String stockName;
  final double quantity;
  StockItem._({
    required this.stockName,
    required this.quantity,
  });
  factory StockItem.fromMap(Map<String, dynamic> map) {
    return StockItem._(
      stockName: map['stock_name'],
      quantity: double.parse(map['quantity'].toString()),
    );
  }
}

class AutocompleteSearch {
  final String id;
  final String name;
  AutocompleteSearch._({
    required this.id,
    required this.name,
  });
  factory AutocompleteSearch.fromMap(Map<String, dynamic> map) {
    return AutocompleteSearch._(
      id: map['id'],
      name: map['name'],
    );
  }
}
// class _StocksPageQueryResolver extends QueryResolver {
//   _StocksPageQueryResolver(QueryResult<Object?> result) : super(result);

//   @override
//   Widget onFinish<List>(data) {
//     return const Center(
//       child: Text('Welcome you in stocks page'),
//     );
//   }

//   @override
//   List? dataFormat<List>() {
//     return result.data?['stocks'] as List?;
//   }
// }

class StocksPage extends HookWidget {
  const StocksPage({super.key});

  @override
  Widget build(BuildContext context) {
    final productNameController = useTextEditingController(text: '');
    final client = useGraphQLClient();
    final isLoading = useState(false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stocks'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TypeAheadFormField(
                    textFieldConfiguration: TextFieldConfiguration(
                      controller: productNameController,
                      decoration: InputDecoration(
                        labelText: 'Product Name',
                        border: const OutlineInputBorder(),
                        suffixIcon: isLoading.value
                            ? const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: SizedBox(
                                    width: 10,
                                    height: 10,
                                    child: CircularProgressIndicator()))
                            : const Icon(Icons.search),
                      ),
                    ),
                    suggestionsCallback: (value) async {
                      final List<AutocompleteSearch> results = [];
                      if (value.isEmpty) return [];
                      isLoading.value = true;
                      final result = await client.query(QueryOptions(
                          document: gql(Queries.autocompleteProductName),
                          variables: {
                            'modelName': value,
                          }));
                      isLoading.value = false;
                      final data = result.data?['autocomplete'];
                      if (data == null) return results;
                      results.addAll((data as List<dynamic>)
                          .map(
                            (searchResult) =>
                                AutocompleteSearch.fromMap(searchResult),
                          )
                          .toList());
                      return results;
                    },
                    itemBuilder: (context, suggestion) {
                      return ListTile(
                        title: Text(suggestion.name),
                      );
                    },
                    transitionBuilder: (context, suggestionsBox, controller) {
                      return suggestionsBox;
                    },
                    onSuggestionSelected: (suggestion) {
                      // productNameController.text = suggestion.name;
                      // _selectedProductId = suggestion.id;
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Please select a product';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () async {},
                  child: const Icon(Icons.search),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // empty widget

            // Expanded(
            //   child: ListView.builder(
            //     itemCount: _stockItemsList.length,
            //     itemBuilder: (context, index) {
            //       return ListTile(
            //         title: Text('Stock ${_stockItemsList[index].stockName}'),
            //         trailing:
            //             Text('quantity ${_stockItemsList[index].quantity}'),
            //       );
            //     },
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
