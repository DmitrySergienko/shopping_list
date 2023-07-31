import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shopping_list/data/categories.dart';
import 'package:shopping_list/models/category.dart';
import 'package:shopping_list/presentation/widget/grocery_item.dart';

class NewItem extends StatefulWidget {
  const NewItem({super.key});

  @override
  State<NewItem> createState() => _NewItem();
}

class _NewItem extends State<NewItem> {
  final _formKey = GlobalKey<FormState>(); //run the Form object
  var _enteredName ='';
  var _enteredQuantity =1;
  var _selectedCategory = categories[Categories.vegetables]!;

  void _saveItem() {

    if(_formKey.currentState!.validate()){

      // 1. save the form
     _formKey.currentState!.save();

     // 2. send POST http request
      var url = Uri.https('flutter-test-2c78d-default-rtdb.firebaseio.com','shopping-list.json');

      http.post(
        url,
        headers: {'Content-Type':'application/json'}, //???
        body: json.encode({  //put our object which we are sending
          'name': _enteredName,
          'quantity': _enteredQuantity,
          'category': _selectedCategory.title
        })
        );

      // 3. go back one screen and put args to pop()
      Navigator.of(context).pop(
      GroceryItem(
          id: DateTime.now().toString(), // create new id manually
          name: _enteredName,
          quantity: _enteredQuantity,
          category: _selectedCategory)
      ); 
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Add new item')),
        body: Padding(
          padding: const EdgeInsets.all(12),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                    maxLength: 50,
                    decoration: const InputDecoration(label: Text('data')),
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          value.trim().length <= 1 ||
                          value.trim().length > 50) {
                        return 'Mast be between 1 - 50 characters';
                      }
                      return null;
                    },
                    onSaved: (value){
                      _enteredName = value!;
                    },
                    ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    //1
                    Expanded(
                      child: TextFormField(
                          decoration:
                              const InputDecoration(label: Text('Quantity')),
                          keyboardType: TextInputType.number,
                          initialValue: _enteredQuantity.toString(),
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                int.tryParse(value) ==
                                    null || // if value is not valid number
                                int.tryParse(value)! <= 0) {
                              return 'Mast be valid positiv number';
                            }
                            return null;
                          },
                          onSaved: (value){
                            _enteredQuantity = int.parse(value!); //value not be null
                          },
                          
                          ),
                    ),
                    //2
                    const SizedBox(width: 8),

                    //3
                    Expanded(
                      child: DropdownButtonFormField(
                        value: _selectedCategory,
                        items: [
                        for (final category in categories.entries)
                          DropdownMenuItem(
                            value: category.value,
                            child: Row(
                              children: [
                                Container(
                                    width: 16,
                                    height: 16,
                                    color: category.value.color),
                                const SizedBox(
                                  width: 6,
                                ),
                                Text(category.value.title)
                              ],
                            ),
                          )
                      ], onChanged: (value) {
                        _selectedCategory = value!;
                      }),
                    ),
                  ],
                ),
                const SizedBox(
                  width: 12,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        _formKey.currentState!.reset();
                      },
                      child: const Text('Reset'),
                    ),
                    ElevatedButton(
                        onPressed: _saveItem, child: const Text('Add item'))
                  ],
                )
              ],
            ),
          ),
        ),
      );
}
