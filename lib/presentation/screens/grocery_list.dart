import 'package:flutter/material.dart';
import 'package:shopping_list/presentation/screens/emptyScreen.dart';
import 'package:shopping_list/presentation/widget/grocery_item.dart';
import 'package:shopping_list/presentation/widget/new_item.dart';

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  final List<GroceryItem> _groceryItems = [];

  final _formKey = GlobalKey<FormState>(); //run the Form object

  // we get arg from NewItem screen using async and await (in case the arg available it will be executed)

  void _addItem() async {
    final newItem = await Navigator.of(context).push<GroceryItem>(
        MaterialPageRoute(builder: (context) => const NewItem()));

    if (newItem == null) {
      return;
    } else {
      setState(() {
        _groceryItems.add(newItem);
      });
    }
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
