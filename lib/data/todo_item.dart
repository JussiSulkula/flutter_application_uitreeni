class TodoItem {
  int id = 0;
  String title = '';
  String description = '';
  DateTime deadline = DateTime.now();
  bool done = false;
  String? fbid; //Firebase id
  String? ownerId; //Firebase user id


  TodoItem(
      {this.id = 0,
       required this.title,
       required this.description,
       required this.deadline,
       required this.done});

  
  //Convert to SQLite
Map<String, dynamic> toMap() {
  return {
    'id': id,
    'title': title,
    'description': description,
    'deadline': deadline.millisecondsSinceEpoch,
    'done': done ? 1:0,
   };
  }
  //for firebase
  TodoItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    deadline = DateTime.parse(json['deadline'] as String);
    done = json['done'] as bool;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'title': title,
    'description': description,
    'deadline': deadline.toString(),
    'done': done,
    
    };  
  }

  Object? toJson() {}
}