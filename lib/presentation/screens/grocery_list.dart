import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shopping_list/data/categories.dart';
import 'package:shopping_list/presentation/screens/emptyScreen.dart';
import 'package:shopping_list/presentation/widget/grocery_item.dart';
import 'package:shopping_list/presentation/widget/new_item.dart';
import 'package:http/http.dart' as http;

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  List<GroceryItem> _groceryItems = [];

  final _formKey = GlobalKey<FormState>(); //run the Form object

  void _loadItems() async {
    final url = Uri.https(
        'flutter-test-2c78d-default-rtdb.firebaseio.com', 'shopping-list.json');
    final response = await http.get(url);

    //we decode json to normal text view
    final Map<String, dynamic> listData = jsonDecode(response.body);

    final List<GroceryItem> loadedItemsList = [];
    for (final item in listData.entries) {
      //типа сравниваем есть в  категория с
      final categoty = categories.entries
          .firstWhere(
              (element) => element.value.title == item.value['category'])
          .value;

      loadedItemsList.add(
        GroceryItem(
          id: item.key,
          name: item.value['name'],
          quantity: item.value['quantity'],
          category: categoty,
        ),
      );
    }
    setState(() {
      _groceryItems = loadedItemsList;
    });
  }

  void _addItem() async {
    final newItem = await Navigator.of(context).push<GroceryItem>(
        MaterialPageRoute(builder: (context) => const NewItem()));

    //send Get request to get the data from the server (Firebase in my case)
    //_loadItems();

    if (newItem == null) {
      return;
    }

    setState(() {
      _groceryItems.add(newItem);
    });
  }

  //we use init metod to be sure load all items in initial loading
  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  @override
  Widget build(BuildContext context) {
    Widget activePage = Form(
      key: _formKey,
      child: Column(
        children: [
          for (final item in _groceryItems)
            Dismissible(
              key: Key(item.id),
              onDismissed: (direction) {
                setState(() {
                  _groceryItems.remove(item);
                });
              },
              child: GroceryItem(
                  id: item.id,
                  name: item.name,
                  quantity: item.quantity,
                  category: item.category),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  setState(() {
                    _groceryItems.clear();
                  });
                },
                child: const Text('Remove all'),
              ),
            ],
          )
        ],
      ),
    );

    if (_groceryItems.isEmpty) {
      activePage = const EmptyScreen();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your groceries'),
        actions: [IconButton(onPressed: _addItem, icon: const Icon(Icons.add))],
      ),
      body: activePage,
    );
  }
}
