import 'package:floor/floor.dart';
import 'todo_item.dart';

@dao
abstract class TodoDao {

  @Query("Select * from TodoItem")
  Future<List<TodoItem>> getAllTodos();

  @insert
  Future<void> insertItem(TodoItem item);

  @delete
  Future<void> deleteItem(TodoItem item);

}