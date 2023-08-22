import 'package:casher_mobile_app/services/autocomplete_services.dart';
import 'package:casher_mobile_app/services/stocks_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class StocksPage extends StatefulWidget {
  const StocksPage({Key? key}) : super(key: key);

  @override
  _StocksPageState createState() => _StocksPageState();
}

class _StocksPageState extends State<StocksPage> {
  final _productNameController = TextEditingController();
  final _productNameFocusNode = FocusNode();
  int? _selectedProductId;
  @override
  void dispose() {
    _productNameController.dispose();
    _productNameFocusNode.dispose();
    super.dispose();
  }

  final List<StockItem> _stockItemsList = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stocks'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              // crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: TypeAheadFormField(
                    textFieldConfiguration: TextFieldConfiguration(
                        controller: _productNameController,
                        decoration: const InputDecoration(
                          labelText: 'Product Name',
                          border: OutlineInputBorder(),
                        )),
                    suggestionsCallback: (value) {
                      return AutocompleteServices.of(context)
                          .autoCompleteProductName(value);
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
                      _productNameController.text = suggestion.name;
                      _selectedProductId = suggestion.id;
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
                  onPressed: () async {
                    if (_selectedProductId == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please select a product'),
                        ),
                      );
                      return;
                    }
                    final stockItems = await StocksServices.of(context)
                        .productInfoFromAllStocks(_selectedProductId!);
                    _stockItemsList.addAll(stockItems);
                    setState(() {});
                  },
                  child: const Icon(Icons.search),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // empty widget

            Expanded(
              child: ListView.builder(
                itemCount: _stockItemsList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('Stock ${_stockItemsList[index].stockName}'),
                    trailing:
                        Text('quantity ${_stockItemsList[index].quantity}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FormData {
  final String productName;

  const FormData({
    required this.productName,
  });
}
