import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_application_uitreeni/data/todo_item.dart';

class FirebaseHelper {
  final DatabaseReference _todoitemsRef = FirebaseDatabase.instance
  .ref()
  .child('todo_items')
  .child(FirebaseAuth.instance.currentUser!.uid);

void saveTodoItem(TodoItem item)  {
  var itemRef = _todoitemsRef.push();
  item.fbid = itemRef.key;
  item.ownerId = FirebaseAuth.instance.currentUser!.uid;
  itemRef.set(item.toJson());
}
Future<List<TodoItem>> getData() async {
    List<TodoItem> items = [];

    DatabaseEvent event = await _todoitemsRef.once();
    var snapshot = event.snapshot;

    for (var child in snapshot.children) {
      var item = TodoItem.fromJson(Map<String, dynamic>.from(child.value as Map));
      item.fbid = child.key;
      items.add(item);
    }
    return items;
  }
  
  
}