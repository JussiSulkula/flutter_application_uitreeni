import 'package:flutter/material.dart';
import 'package:flutter_application_uitreeni/data/todo_item.dart';
import 'package:flutter_application_uitreeni/data/todo_list_manager.dart';
import 'package:flutter_application_uitreeni/views/input_view.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TodoListView extends StatelessWidget {
  
  const TodoListView({super.key});


  @override
  Widget build(BuildContext context) {
    return Consumer<TodoListManager>(
      builder: (context, listManager, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Todo list"),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.school),
                tooltip: 'Main page',
                onPressed: () {
                  Navigator.pushNamed(context, '/main');
                },
              ),
              IconButton(
                icon: Icon(Icons.add),
                tooltip: 'Lisää uusi',
                onPressed: () {
                  Navigator.pushNamed(context, '/input');
                },
              )
            ],
          ),
          body: ListView.builder(
            itemCount: listManager.items.length,
            itemBuilder: (context, index) {
              return _BuildTodoCard(listManager.items[index], context, listManager);
            }),
          );
        });
  }
}

Center _BuildTodoCard(item, BuildContext context, TodoListManager listManager) {
  return Center(
    child: Card(
      child: Column(
        children: [
          ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text(item.title), 
              Text(DateFormat('dd.MM.yyyy').format(item.deadline))],),
            
            subtitle: Text(item.description),
            trailing: IconButton(
                onPressed: () {
                  listManager.toggleDone(item);
                },
                icon: Icon(Icons.done,
                    color: item.done ? Colors.green : Colors.grey)),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
            TextButton(onPressed: () {
              Navigator.push(context,
              MaterialPageRoute(
                builder: (context) => InputView(item: item))
              );
            }, child: Text("Muokkaa")),
            TextButton(onPressed: () {
              listManager.delete(item);
            }, 
            child: Text("Poista")),
          ],
          )
        ],
      ),
    ),
  );
}
class ImageSection extends StatelessWidget {
  const ImageSection({super.key, required this.image});

  final String image;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      image,
      width: 600,
      height: 350,
      fit: BoxFit.cover,
    );
  }
}