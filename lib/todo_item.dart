import 'package:floor/floor.dart';

@entity
class TodoItem {
  static int ID = 1;

  @primaryKey
  final int id;

  final String name;
  final int quantity;

  TodoItem(this.id, this.name, this.quantity) {
    if (id >= ID) {
      ID = id + 1;
    }
  }
}