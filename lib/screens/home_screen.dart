import 'package:flutter/material.dart';
import 'package:todo_app/data/db_Helper.dart';
import 'package:todo_app/screens/task_screen.dart';
import 'package:todo_app/widgets/widgets.dart';


class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DbHelper _dbHelper = DbHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF7349FE),
      appBar: AppBar(
        toolbarHeight: 80.0,
        elevation: 0.0,
        shadowColor: Color(0xFF7349FE),
        centerTitle: true,
        title: Text("Todo App",style:TextStyle(
          fontSize: 26.0,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),),
        backgroundColor: Color(0xFF7349FE),
      ),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 24.0,vertical: 20.0),
          decoration: BoxDecoration(
            color: Color(0xFFF6F6F6),
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(25.0),
              topLeft: Radius.circular(25.0)
            )
          ),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ListOfWidgets(),
                  ),
                ],
              ),

            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add,color: Colors.white,),
        backgroundColor: Color(0xFF7349FE),
        onPressed: (){
          Navigator.push(context,MaterialPageRoute(builder: (context)=>TaskScreen(task: null,))
          ).then((value){
            setState((){
            });
          });
        },
      ),
    );
  }


  ListOfWidgets() {
    return FutureBuilder(
      future: _dbHelper.getTasks(),
      builder: (context, snapshot){
        return ScrollConfiguration(
          behavior: NoGlowBehaviour(),
          child: snapshot.data != null ? ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index){
                return GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>TaskScreen(task: snapshot.data[index],))).then((value){
                      setState(() {

                      });
                    });
                  },
                  child: Row(
                    children: [
                      Expanded(
                        child: TaskCard(
                          title: snapshot.data[index].title,
                          description: snapshot.data[index].description,
                          id: snapshot.data[index].id,
                        ),
                      ),

                    ],
                  ),
                );
              }
          ):Container(),
        );
      },
    );
  }
}