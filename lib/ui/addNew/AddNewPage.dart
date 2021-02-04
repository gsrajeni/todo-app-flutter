import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:todo/core/database/MyDatabase.dart';
import 'package:todo/core/style/color.dart';
import 'package:todo/core/style/styles.dart';
import 'package:todo/core/validator/validator.dart';
import 'package:todo/model/category/CategoryDao.dart';
import 'package:todo/model/category/CategoryDataModel.dart';
import 'package:todo/model/todo/TodoDao.dart';
import 'package:todo/model/todo/TodoDataModel.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';

class AddNewPage extends StatefulWidget {
  TodoDataModel todoDataModel;
  CategoryDataModel selected;
  AddNewPage({this.todoDataModel});

  @override
  _AddNewPageState createState() => _AddNewPageState();
}

class _AddNewPageState extends State<AddNewPage> {
  GlobalKey<FormState> _key = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.todoDataModel == null)
      widget.todoDataModel = TodoDataModel(timestamp: DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    if(widget.todoDataModel == null) widget.todoDataModel = TodoDataModel(timestamp: DateTime.now());
    return Scaffold(
      appBar: AppBar(
        title: StatefulBuilder(
          builder:(context, myState)=> Row(
            children: [
              Expanded(
                  child: Hero(
                    tag: "add new",
                    child: Text(
                DateFormat("dd MMM, yyyy hh:mm a")
                      .format(widget.todoDataModel.timestamp),
                style: Theme.of(context).textTheme.caption,
              ),
                  )),
              Expanded(
                  child: FlatButton.icon(
                      onPressed: () {
                        DatePicker.showDateTimePicker(context,
                            showTitleActions: true,
                            onChanged: (date) {
                          myState(() {
                            widget.todoDataModel.timestamp = date;
                          });
                        }, onConfirm: (date) {
                          print('confirm $date');
                        }, currentTime: DateTime.now());
                      },
                      icon: Icon(Icons.access_time),
                      label: Text("change")))
            ],
          ),
        ),
        actions: [
          IconButton(
              icon: Icon(
                Icons.save,
                color: Colors.green,
              ),
              onPressed: () async {
                if (_key.currentState.validate()) {
                  _key.currentState.save();
                  final database = await $FloorMyDatabase
                      .databaseBuilder('app_database.db')
                      .build();
                  TodoDao todoDao = database.todoDao;
                  widget.todoDataModel.isDeleted = false;
                  if (widget.todoDataModel.id == null)
                    await todoDao.insertTodo(widget.todoDataModel);
                  else
                    await todoDao.updateTodo(widget.todoDataModel);
                  Navigator.of(context).pop(widget.todoDataModel);
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
                  initialValue: widget.todoDataModel?.title ?? "",
                  validator: Validator.validateText,
                  onSaved: (value) => widget.todoDataModel.title = value,
                  decoration: InputDecoration(
                      hintText: "Input the title",
                      labelText: "Title",
                      border: OutlineInputBorder()),
                ),
                SizedBox(
                  height: 16.h,
                ),
                TextFormField(
                  initialValue: widget.todoDataModel?.description ?? "",
                  validator: Validator.validateText,
                  onSaved: (value) => widget.todoDataModel.description = value,
                  minLines: 5,
                  maxLines: 20,
                  decoration: InputDecoration(
                      hintText: "Input the description",
                      labelText: "Description",
                      border: OutlineInputBorder()),
                ),
                SizedBox(
                  height: 16.h,
                ),
                FutureBuilder(
                  future: _getCatagories(),
                  builder: (context,
                      AsyncSnapshot<List<DropdownMenuItem<CategoryDataModel>>>
                          snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting)
                      return Text("Loading Category");
                    else if (snapshot.hasData) {
                      return DropdownButtonFormField(
                          onTap: () => FocusScope.of(context).unfocus(),
                          value: widget.selected,
                          onSaved: (CategoryDataModel element) =>
                              widget.todoDataModel?.categoryId = element.id,
                          validator: (CategoryDataModel element) =>
                              Validator.validateDropDown(element),
                          decoration: InputDecoration(
                              hintText: "Select a category",
                              labelText: "Category",
                              border: OutlineInputBorder()),
                          items: snapshot.data,
                          onChanged: (value) {});
                    } else
                      return Container();
                  },
                ),
                SizedBox(
                  height: 8.h,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Hero(
                        tag: "add category",
                        child: FlatButton(
                          child: Text("Add Category"),
                          onPressed: () async {
                            await Navigator.pushNamed(
                                context, "/addNew/category");
                            setState(() {});
                          },
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<List<DropdownMenuItem<CategoryDataModel>>> _getCatagories() async {
    final database =
        await $FloorMyDatabase.databaseBuilder('app_database.db').build();
    CategoryDao categoryDao = database.categoryDao;
    List<CategoryDataModel> categoryList = await categoryDao.findAllCategory();
    if (categoryList == null)
      return null;
    else {
      List<DropdownMenuItem<CategoryDataModel>> dropDownList = [];
      categoryList.forEach((element) {
        if (element.id == widget.todoDataModel.categoryId)
          widget.selected = element;
        dropDownList.add(DropdownMenuItem(
            child: Container(
              width: 280.w,
              height: 40.h,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    Icons.circle,
                    color: element.color,
                  ),
                  SizedBox(
                    width: 8.w,
                  ),
                  Text(element.name),
                  Spacer(),
                  IconButton(
                      icon: Icon(
                        Icons.delete,
                        color: MyColor.warningRedColor,
                      ),
                      onPressed: () async {
                        final database = await $FloorMyDatabase
                            .databaseBuilder('app_database.db')
                            .build();
                        CategoryDao categoryDao = database.categoryDao;
                        categoryDao.removeCategory(element);
                        setState(() {});
                      }),
                  IconButton(
                      icon: Icon(
                        Icons.edit,
                        color: Colors.green,
                      ),
                      onPressed: () async {
                        var result = await Navigator.pushNamed(
                            context, "/addNew/category",
                            arguments: element);
                        if (result != null)
                          setState(() {
                            element = result;
                          });
                      }),
                ],
              ),
            ),
            value: element));
      });
      return dropDownList;
    }
  }
}
