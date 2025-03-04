//author: yimi ding
import 'package:flutter/material.dart';
import 'database.dart';
import 'todo_item.dart';

void main() async {
  // Initialize Flutter binding
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize the database
  final database = await $FloorAppDatabase
      .databaseBuilder('shopping_list.db')
      .build();

  runApp(MyApp(database: database));
}

class MyApp extends StatelessWidget {
  final AppDatabase database;

  const MyApp({super.key, required this.database});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shopping List',
      home: MyHomePage(database: database),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final AppDatabase database;

  const MyHomePage({super.key, required this.database});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<TodoItem> items = [];   // List用于存储购物清单项目
  // TextEditingController 用于控制和管理TextField的输入
  final TextEditingController _itemController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadItems(); // Load items from database when app starts (Requirement 2)
  }

  // Load items from database
  Future<void> _loadItems() async {
    final loadedItems = await widget.database.todoDao.findAllTodoItems();
    setState(() {
      items = loadedItems;
      // Update ID counter if needed
      if (items.isNotEmpty) {
        TodoItem.ID = items.map((item) => item.id).reduce((a, b) => a > b ? a : b) + 1;
      }
    });
  }

  // dispose方法在widget被销毁时调用
  @override
  void dispose() {
    _itemController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  // 创建一个函数来返回列表页面的Widget
  Widget ListPage() {
    return Column(
      children: [
        // 输入部分：包含两个TextField和一个按钮
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              // Expanded widget让子widget填充可用空间
              // flex参数决定占据空间的比例
              Expanded(
                flex: 2,
                child: TextField(
                  controller: _itemController,
                  decoration: const InputDecoration(
                    hintText: 'Type the item here',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 2,
                child: TextField(
                  controller: _quantityController,
                  decoration: const InputDecoration(
                    hintText: 'Type the quantity here',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {
                  // 验证输入不为空
                  if (_itemController.text.isNotEmpty &&
                      _quantityController.text.isNotEmpty) {

                    // Create new item
                    final newItem = TodoItem(
                      TodoItem.ID,
                      _itemController.text,
                      int.tryParse(_quantityController.text) ?? 1,
                    );

                    // Insert into database (Requirement 1)
                    widget.database.todoDao.insertTodoItem(newItem);

                    setState(() {
                      // Add to local list
                      items.add(newItem);
                      // 清空输入框
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
        // ListView部分
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
                              // Delete from database (Requirement 3)
                              widget.database.todoDao.deleteTodoItem(items[index]);

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
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Text(
                    '${index + 1}: ${items[index].name} quantity: ${items[index].quantity}',
                    style: const TextStyle(fontSize: 16),
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