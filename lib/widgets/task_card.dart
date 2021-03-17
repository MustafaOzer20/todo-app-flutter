import 'package:flutter/material.dart';
import 'package:todo_app/data/db_Helper.dart';

class TaskCard extends StatelessWidget {
  final String title;
  final String description;
  final int id;

  const TaskCard({
    Key key,
    this.title,
    this.description,
    @required this.id
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom:20.0),
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: 32.0,
        horizontal: 24.0,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
      ),
      //margin: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title ?? "(Unnamed Task)",
                  style: TextStyle(
                    color: Color(0xFF211551),
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Done(id),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(
              top: 10.0,
            ),
            child: Text(
                description ?? "No Description Added",
                style: TextStyle(
                  fontSize: 16.0,
                  color: Color(0xFF86829D),
                  height: 1.5,
                ),
            ),
          ),
        ],
      ),
    );
  }

  Done(int id) {
    DbHelper _dbHelper = DbHelper();
    return FutureBuilder(
        future: _dbHelper.getTodo(id),
        builder: (context, todos) {
          int count = 0;
          int allTodoCount = 0;
          if (todos.data != null) {
            allTodoCount = todos.data.length;

            for (int i = 0; i < allTodoCount; i++) {
              if (todos.data[i].isDone == 1)
                count += 1;
            }
          }
          bool allDone = count == allTodoCount && count!=0 ? true:false;
          return Container(
            child: Text('${count} / ${allTodoCount}  done',style: TextStyle(color: allDone ? Colors.green : Colors.red),),
          );
        }
    );
  }
}
