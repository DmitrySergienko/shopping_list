import 'package:flutter/material.dart';
import 'package:shopping_list/models/category.dart';

class GroceryItem extends StatelessWidget {
  const GroceryItem({
    super.key,
    required this.id,
    required this.name,
    required this.quantity,
    required this.category,
  });

  final String id;
  final String name;
  final int quantity;
  final Category category;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: 24.0,
            height: 24.0,
            color: category.color,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(name),
                Text(quantity.toString()),
              ],
            ),
          )
        ],
      ),
    );
  }
}
