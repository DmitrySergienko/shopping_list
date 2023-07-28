import 'package:flutter/material.dart';
import 'package:shopping_list/data/dummy_items.dart';
import 'package:shopping_list/presentation/widget/grocery_item.dart';
import 'package:shopping_list/presentation/widget/new_item.dart';

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  void _onPressed() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const NewItem()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your groceries'),
        actions: [
          IconButton(onPressed: _onPressed, icon: const Icon(Icons.add))
        ],
      ),
      body: Column(
        children: [
          for (final item in groceryItems)
            GroceryItem(
                id: item.id,
                name: item.name,
                quantity: item.quantity,
                category: item.category),
        ],
      ),
    );
  }
}
