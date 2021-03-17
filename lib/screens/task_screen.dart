import 'package:flutter/material.dart';

import 'package:todo_app/data/db_Helper.dart';
import 'package:todo_app/models/models.dart';
import 'package:todo_app/widgets/widgets.dart';


class TaskScreen extends StatefulWidget {
  final Task task;

  const TaskScreen({Key key, @required this.task}) : super(key: key);

  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  DbHelper _dbHelper = DbHelper();

  String _taskTitle = "";
  String _taskDesc = "";

  int _taskId = 0;

  FocusNode _titleFocus;
  FocusNode _descriptionFocus;
  FocusNode _todoFocus;

  bool _contentVisible = false;

  @override
  void initState() {
    if (widget.task != null) {
      _taskTitle = widget.task.title;
      _taskDesc = widget.task.description;
      _taskId = widget.task.id;
      _contentVisible = true;
    }
    _titleFocus = FocusNode();
    _descriptionFocus = FocusNode();
    _todoFocus = FocusNode();

    super.initState();
  }

  @override
  void dispose() {
    _titleFocus.dispose();
    _descriptionFocus.dispose();
    _todoFocus.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.task!=null ? Color(0xFF7349FE):Color(0xFFF6F6F6),
      appBar: AppBar(
        toolbarHeight: 80.0,
        elevation: 0.0,
        shadowColor: Color(0xFF7349FE),
        centerTitle: true,
        backgroundColor: Color(0xFF7349FE),
        title: appBarTitle(),
        actions: [
          Visibility(
            visible: _contentVisible,
            child: IconButton(
              onPressed: () async {
                if(_taskId != 0) {
                  await _dbHelper.deleteTask(_taskId);
                  Navigator.pop(context);
                }
              },
              icon: Icon(Icons.delete_forever),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(15.0),
          decoration: BoxDecoration(
            color: Color(0xFFF6F6F6),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25.0),
              topRight: Radius.circular(25.0),
            )
          ),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Visibility(
                    visible: _contentVisible,
                    child: Padding(
                      padding: EdgeInsets.only(
                        bottom: 12.0,
                      ),
                      child: TextField(
                        focusNode: _descriptionFocus,
                        onSubmitted: (value) async {
                          if(value != ""){
                            if(_taskId != 0){
                              await _dbHelper.updateTaskDescription(_taskId, value);
                              _taskDesc = value;
                            }
                          }
                          _todoFocus.requestFocus();
                        },
                        controller: TextEditingController()..text = _taskDesc,
                        decoration: InputDecoration(
                          hintText: "Enter Description for the task...",
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 24.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: _contentVisible,
                    child: FutureBuilder(
                      initialData: [],
                      future: _dbHelper.getTodo(_taskId),
                      builder: (context, snapshot) {
                        return Expanded(
                          child: ListView.builder(
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () async {
                                  if(snapshot.data[index].isDone == 0){
                                    await _dbHelper.updateTodoDone(snapshot.data[index].id, 1);
                                  } else {
                                    await _dbHelper.updateTodoDone(snapshot.data[index].id, 0);
                                  }
                                  setState(() {});
                                },
                                child: TodoWidget(
                                  text: snapshot.data[index].title,
                                  isDone: snapshot.data[index].isDone == 0
                                      ? false
                                      : true,
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  Visibility(
                    visible: _contentVisible,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 24.0,
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 20.0,
                            height: 20.0,
                            margin: EdgeInsets.only(
                              right: 12.0,
                            ),
                            decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(6.0),
                                border: Border.all(
                                    color: Color(0xFF86829D), width: 1.5)),
                          ),
                          Expanded(
                            child: TextField(
                              focusNode: _todoFocus,
                              controller: TextEditingController()..text = "",
                              onSubmitted: (value) async {
                                // Check if the field is not empty
                                if (value != "") {
                                  if (_taskId != 0) {
                                    DbHelper _dbHelper = DbHelper();
                                    Todo _newTodo = Todo(
                                      title: value,
                                      isDone: 0,
                                      taskId: _taskId,
                                    );
                                    await _dbHelper.insertTodo(_newTodo);
                                    setState(() {});
                                    _todoFocus.requestFocus();
                                  }
                                }
                              },
                              decoration: InputDecoration(
                                hintText: "Enter Todo item...",
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  appBarTitle() {
    return TextField(
      focusNode: _titleFocus,
      onSubmitted: (value) async {
        // Check if the field is not empty
        if (value != "") {
          // Check if the task is null
          if (widget.task == null) {
            Task _newTask = Task(title: value);
            _taskId = await _dbHelper.insertTask(_newTask);
            setState(() {
              _contentVisible = true;
              _taskTitle = value;
            });
          } else {
            await _dbHelper.updateTaskTitle(_taskId, value);
            print("Task Updated");
          }
          _descriptionFocus.requestFocus();
        }
      },
      controller: TextEditingController()
        ..text = _taskTitle,
      decoration: InputDecoration(
        hintText: "Enter Task Title",
        hintStyle: TextStyle(color: Colors.white),
        border: InputBorder.none,
      ),
      style: TextStyle(
        fontSize: 26.0,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }
}
