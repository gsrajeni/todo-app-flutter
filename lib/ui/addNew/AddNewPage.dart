import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:todo/core/database/MyDatabase.dart';
import 'package:todo/core/validator/validator.dart';
import 'package:todo/model/todo/TodoDao.dart';
import 'package:todo/model/todo/TodoDataModel.dart';
class AddNewPage extends StatelessWidget {
  TodoDataModel todoDataModel = TodoDataModel();
  GlobalKey<FormState> _key = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Hero(tag:"add new",child: Material(color: Colors.transparent,child: Text("Add New"))),
      actions: [
        IconButton(icon: Icon(Icons.save, color: Colors.green,), onPressed: ()async{
          if(_key.currentState.validate()){
            _key.currentState.save();
            final database = await $FloorMyDatabase.databaseBuilder('app_database.db').build();
            TodoDao todoDao =  database.todoDao;
            todoDataModel.isDeleted = false;
            todoDataModel.timestamp = DateTime.now();
            await todoDao.insertTodo(todoDataModel);
            Navigator.pop(context);
          }
        })
      ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Form(
            key: _key,
            child: Column(
              children: [
                TextFormField(
                  validator: Validator.validateText,
                  onSaved:(value)=> todoDataModel.title = value ,
                  decoration: InputDecoration(
                    hintText: "Input the title",
                    labelText: "Title",
                    border: OutlineInputBorder(
                    )
                  ),
                ),
                SizedBox(height: 16.h,),
                TextFormField(
                  validator: Validator.validateText,
                  onSaved:(value)=> todoDataModel.description = value ,
                  minLines: 5,
                  maxLines: 20,
                  decoration: InputDecoration(
                    hintText: "Input the description",
                    labelText: "Description",
                    border: OutlineInputBorder(
                    )
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
