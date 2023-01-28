
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:todo/Box/Boxes.dart';
import 'package:todo/Models/NotesModel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  var titleController=TextEditingController();
  var desController=TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Todo List'),),
        body: ValueListenableBuilder<Box<NotesModel>>(
            valueListenable: Boxes.getData().listenable(),
            builder: (BuildContext context,box, _) {
              var  data= box.values.toList().cast<NotesModel>();
              return  ListView.builder(
                itemCount: box.length,
                reverse: true,
                shrinkWrap: true,
                itemBuilder: (context , index){
                  return Card(
                    margin: EdgeInsets.all(10),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 15),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
                        Row(children: [
                          Text(data[index].title.toString(),style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                          Spacer(),
                          GestureDetector(
                            child: Icon(Icons.edit),
                            onTap: (){
                              _upDateDialog(data[index],data[index].title.toString() , data[index].description.toString());
                            },
                          ),
                          SizedBox(width: 5,),
                          GestureDetector(
                            child: Icon(Icons.delete,color: Colors.red,),
                            onTap: (){
                              DeleteFunctions(data[index]);
                            },
                          ),

                        ],),
                        Text(data[index].description.toString()),
                      ],),
                    ),
                  );
                },
              );
            }
        ),

        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () async{
            _ShowDialogBox();
          },
        ),

      ),
    );
  }


  void DeleteFunctions(NotesModel notesModel) async{
    await notesModel.delete();
  }

  Future<void> _upDateDialog(NotesModel notesModel,String title, String description){

    titleController.text= title;
    desController.text= description;
    
    return showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: Text("Notes Box"),
            content: SingleChildScrollView(
              child:  Column(children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintText: 'Enter Title',
                  ),
                ),
                SizedBox(height: 15,),
                TextField(
                  controller: desController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintText: 'Enter Descriptions',
                  ),
                ),

              ],),
            ),
            actions: [
              TextButton(
                child: Text('Cancel'),
                onPressed: (){
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: Text('Edit'),
                onPressed: ()async{

                  notesModel.title= titleController.text.toString();
                  notesModel.description= desController.text.toString();
                  await notesModel.save();
                  titleController.clear();
                  desController.clear();

                  Navigator.pop(context);
                },
              ),
            ],
          );
        }
    );

  }

  Future<void> _ShowDialogBox(){
    
    return showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          title: Text("Notes Box"),
          content: SingleChildScrollView(
            child:  Column(children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  hintText: 'Enter Title',
                ),
              ),
              SizedBox(height: 15,),
              TextField(
                controller: desController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  hintText: 'Enter Descriptions',
                ),
              ),

            ],),
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: (){
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text('Add'),
              onPressed: (){

                final data= NotesModel(title: titleController.text.toString(), description: desController.text.toString());
                final box= Boxes.getData();
                box.add(data);

                data.save();
                titleController.clear();
                desController.clear();

                Navigator.pop(context);
              },
            ),
          ],
        );
      }
    );
    
  }

  
}
