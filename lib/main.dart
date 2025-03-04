import 'package:flutter/material.dart';
import 'database.dart';
import 'todo_item.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final database = await $FloorAppDatabase.databaseBuilder('app_database.db').build();
  runApp(MyApp(database: database));
}

class MyApp extends StatelessWidget {
  final AppDatabase database;

  const MyApp({super.key, required this.database});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: TodoListScreen(database: database),
    );
  }
}

class TodoListScreen extends StatefulWidget {
  final AppDatabase database;

  const TodoListScreen({super.key, required this.database});

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  List<TodoItem> todos = [];
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadTodos();
  }

  Future<void> _loadTodos() async {
    final todoDao = widget.database.todoDao;
    final todoList = await todoDao.getAllTodos();
    setState(() {
      todos = todoList;
    });
  }

  Future<void> _addTodo(String text) async {
    if (text.isNotEmpty) {
      final todo = TodoItem(TodoItem.ID, text);
      await widget.database.todoDao.insertItem(todo);
      _controller.clear();
      _loadTodos();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Todo List')),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Enter todo item',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => _addTodo(_controller.text),
                  child: Text('Add'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: todos.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(todos[index].todoItem),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () async {
                      await widget.database.todoDao.deleteItem(todos[index]);
                      _loadTodos();
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}