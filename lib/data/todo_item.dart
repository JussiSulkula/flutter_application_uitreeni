class TodoItem {
  int id = 0;
  String title = '';
  String description = '';
  DateTime deadline = DateTime.now();
  bool done = false;

  TodoItem(
      {this.id = 0,
       required this.title,
       required this.description,
       required this.deadline,
       required this.done});

  
  
Map<String, dynamic> toMap() {
  return {
    'id': id,
    'title': title,
    'description': description,
    'deadline': deadline.millisecondsSinceEpoch,
    'done': done ? 1:0,
   };
  }
}