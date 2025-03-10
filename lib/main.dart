//author: yimi ding
// date: 3/10/2025
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
  TodoItem? selectedItem = null; // 用于存储用户选择的项目

  @override
  void initState() {
    super.initState();
    _loadItems(); // Load items from database when app starts
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

                    // Insert into database
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
                // 修改长按为点击事件
                onTap: () {
                  setState(() {
                    // 设置选中的项目
                    selectedItem = items[index];
                  });
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

  // 创建详情页面Widget
  Widget DetailsPage() {
    if (selectedItem != null) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Item Details',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text('Name: ${selectedItem!.name}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Quantity: ${selectedItem!.quantity}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Database ID: ${selectedItem!.id}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // 删除选中的项目
                    widget.database.todoDao.deleteTodoItem(selectedItem!);
                    setState(() {
                      items.removeWhere((item) => item.id == selectedItem!.id);
                      selectedItem = null; // 清除选中项
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child: Text('Delete'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // 关闭详情页面
                    setState(() {
                      selectedItem = null;
                    });
                  },
                  child: Text('Close'),
                ),
              ],
            ),
          ],
        ),
      );
    } else {
      return Center(
        child: Text('No item selected'),
      );
    }
  }

  // 响应式布局函数
  Widget reactiveLayout() {
    // 获取屏幕尺寸
    var size = MediaQuery.of(context).size;
    var height = size.height;
    var width = size.width;

    // 判断是否为平板布局（横屏且宽度>720像素）
    if ((width > height) && (width > 720)) {
      // 平板布局：左侧列表，右侧详情
      return Row(
        children: [
          Expanded(
            flex: 2, // 列表占据2/5的宽度
            child: ListPage(),
          ),
          Expanded(
            flex: 3, // 详情占据3/5的宽度
            child: DetailsPage(),
          ),
        ],
      );
    } else {
      // 手机布局：如果有选中项目则显示详情，否则显示列表
      if (selectedItem == null) {
        return ListPage();
      } else {
        return DetailsPage();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping List'),
      ),
      body: reactiveLayout(), // 使用响应式布局
    );
  }
}