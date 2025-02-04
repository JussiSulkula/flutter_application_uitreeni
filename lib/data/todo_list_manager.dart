import 'dart:collection';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_application_uitreeni/data/db_helper.dart';
import 'package:flutter_application_uitreeni/data/firebase_helper.dart';
import 'package:flutter_application_uitreeni/data/todo_item.dart';

class TodoListManager extends ChangeNotifier {
  final List<TodoItem> _items = [];
  final DatabaseHelper dbHelper = DatabaseHelper.instance;
  final fbHelper = FirebaseHelper();

  Future<void> init() async {
    loadFromFirebase();
  }

  UnmodifiableListView<TodoItem> get items => 
  UnmodifiableListView(_items.reversed);

  void addItem(TodoItem item) {
    if(_items.isEmpty) {
      item.id = 1;
    } else{
    item.id = _items.last.id + 1;
    }
   _items.add(item);
  dbHelper.insert(item);
  fbHelper.saveTodoItem(item);
   notifyListeners();
  
  }
  void delete(TodoItem item) {
    _items.remove(item);
    dbHelper.delete(item);
    notifyListeners();
  }
  void update(TodoItem item) {
    TodoItem? oldItem;
    for(TodoItem i in _items) {
      if(i.id == item.id) {
        oldItem = i;
        break;
      }
    }
    if(oldItem != null) {
      log("ToDOLISTMANAGER: Editoidaan: ${oldItem.id}");
      oldItem.title = item.title;
      oldItem.description = item.description;
      oldItem.deadline = item.deadline;
      oldItem.done = item.done;
      dbHelper.update(oldItem);
      
      notifyListeners();
    }
  }
  void toggleDone(TodoItem item) {
    item.done = !item.done;
    dbHelper.update(item);
    notifyListeners();
  }
  Future<void> loadFromDB() async {
    final list = await dbHelper.queryAllRows();
    for(TodoItem item in list) {
     _items.add(item);
    }
    notifyListeners();
  }
  void loadFromFirebase() async {
    final list = await fbHelper.getData();
    
    for(TodoItem item in list) {
      _items.add(item);
    }
    notifyListeners();
  }
  
}