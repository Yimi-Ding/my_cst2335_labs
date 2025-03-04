import 'package:floor/floor.dart';
import 'todo_item.dart';

@dao
abstract class TodoDao {

  @Query('SELECT * FROM TodoItem')
  Future<List<TodoItem>> findAllTodoItems();

  @insert
  Future<void> insertTodoItem(TodoItem item);

  @delete
  Future<void> deleteTodoItem(TodoItem item);

}