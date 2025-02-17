import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shopping List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<ShoppingItem> items = [];
  final TextEditingController _itemController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

  @override
  void dispose() {
    _itemController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  Widget ListPage() {
    return Column(
      children: [
        // Input row with text fields and add button
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: TextField(
                  controller: _itemController,
                  decoration: const InputDecoration(
                    labelText: 'Item Name',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _quantityController,
                  decoration: const InputDecoration(
                    labelText: 'Quantity',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {
                  if (_itemController.text.isNotEmpty &&
                      _quantityController.text.isNotEmpty) {
                    setState(() {
                      items.add(ShoppingItem(
                        _itemController.text,
                        int.tryParse(_quantityController.text) ?? 1,
                      ));
                      _itemController.clear();
                      _quantityController.clear();
                    });
                  }
                },
                child: const Text('Add'),
              ),
            ],
          ),
        ),
        // List view of items
        Expanded(
          child: items.isEmpty
              ? const Center(
            child: Text('There are no items in the list'),
          )
              : ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onLongPress: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Delete Item'),
                        content: const Text('Do you want to delete this item?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('No'),
                          ),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                items.removeAt(index);
                              });
                              Navigator.of(context).pop();
                            },
                            child: const Text('Yes'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${index + 1}. ${items[index].name}'),
                        Text('Quantity: ${items[index].quantity}'),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping List'),
      ),
      body: ListPage(),
    );
  }
}

class ShoppingItem {
  final String name;
  final int quantity;

  ShoppingItem(this.name, this.quantity);
}