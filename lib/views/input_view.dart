import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_application_uitreeni/data/todo_item.dart';
import 'package:flutter_application_uitreeni/data/todo_list_manager.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class InputView extends StatelessWidget {
  final TodoItem? item;
  const InputView({super.key, this.item});

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
      title: const Text("Lisää uusi tehtävä"),) ,
      body: InputForm(item:item),
    
    );  
  }

}

class InputForm extends StatefulWidget{
  final TodoItem? item;
  const InputForm({super.key, this.item});

  @override
  State<StatefulWidget> createState(){
    return _InputFormState();
  } 
}
class _InputFormState extends State<InputForm>{
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _description = '';
  DateTime _deadline = DateTime.now();
  bool _done = false;
  int _id = 0;
  bool _isEdit = false;
  
  @override
  void initState(){
    if(widget.item != null){
      _id = widget.item!.id;
      _title = widget.item!.title;
      _description = widget.item!.description;
      _deadline = widget.item!.deadline;
      _done = widget.item!.done;
      _isEdit = true;
      log("Editoidaan itemiä: ${widget.item!.id}");
    }
    super.initState();

  }

  @override
  Widget build(BuildContext context){
    return Center(
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              initialValue: _title,
                decoration: const InputDecoration(
                    labelText: 'Nimi', hintText: 'Tehtävän nimi'),
                onChanged: (value) {
                  setState(() {
                    _title = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nimi ei voi olla tyhjä';
                  }
                  return null;
                },
              ),
              TextFormField(
                initialValue: _description,
                decoration: const InputDecoration(
                    labelText: 'Kuvaus', hintText: 'Tehtävän kuvaus'),
                onChanged: (value) {
                  setState(() {
                    _description = value;
                  });
                },
                minLines: 3,
                maxLines: 3,
              ),
              _FormDatePicker(date: _deadline,
                 onChanged: (value) {
                  setState(() {
                    _deadline = value;
                  });
                }),
              Row(
                children: [
                  Checkbox(
                    value: _done,
                   onChanged: (value){
                     setState(() {
                       _done = value!;
                     });
                   },
                  ),
                  const Text('Valmis'),
                ],
                  ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {

                    TodoItem item = TodoItem(
                      title: _title,
                      description: _description,
                      deadline: _deadline,
                      done: _done,
                      id: _id,
                    );
                    //TODO! Tallenna item jonnekin ja logit
                    log(item.title);
                    log(item.description);
                    log(item.deadline.toString());
                    log(item.done.toString());
                    
                    if(!_isEdit){
                      Provider.of<TodoListManager>(context, listen: false).addItem(item);
                    } 
                    else{
                      Provider.of<TodoListManager>(context, listen: false).update(item);

                    }
                    
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Lisätty uusi')),
                    );
                    Navigator.pop(context);
                  }
                },
                child: _isEdit?const Text("Muokkaa") : const Text('Lisää'),
              )
            ],
          
        ),
      ),
    );

  }

}
class _FormDatePicker extends StatefulWidget {
  final DateTime date;
  final ValueChanged<DateTime> onChanged;

  const _FormDatePicker({
    required this.date,
    required this.onChanged,
  });

  @override
  State<_FormDatePicker> createState() => _FormDatePickerState();
}

class _FormDatePickerState extends State<_FormDatePicker> {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              'Deadline',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Text(
              DateFormat('d.M.yyyy').format(widget.date),
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
        TextButton(
          child: const Text('Edit'),
          onPressed: () async {
            var newDate = await showDatePicker(
              context: context,
              initialDate: widget.date,
              firstDate: DateTime(1900),
              lastDate: DateTime(2100),
            );

            // Don't change the date if the date picker returns null.
            if (newDate == null) {
              return;
            }

            widget.onChanged(newDate);
          },
        )
      ],
    );
  }
}