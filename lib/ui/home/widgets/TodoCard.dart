import 'package:flutter/material.dart';
import 'package:todo/core/database/MyDatabase.dart';
import 'package:todo/core/style/color.dart';
import 'package:todo/model/category/CategoryDao.dart';
import 'package:todo/model/todo/TodoDao.dart';
import 'package:todo/model/todo/TodoDataModel.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TodoCard extends StatefulWidget {
  TodoDataModel data;
  Function(TodoDataModel) onRemoveTodo;

  TodoCard(this.data, this.onRemoveTodo);

  @override
  _TodoCardState createState() => _TodoCardState();
}

class _TodoCardState extends State<TodoCard> {
  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, myState) => Dismissible(
        key: UniqueKey(),
        onDismissed: (direction) async {
          await removeTodo(widget.data);
          widget.onRemoveTodo.call(widget.data);
        },
        background: Container(
          color: Colors.red,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Delete",
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    .copyWith(color: Colors.white),
              ),
            ),
          ),
        ),
        child: FutureBuilder(
          initialData: Colors.white,
          future: _getColor(widget.data.categoryId),
          builder: (context, AsyncSnapshot<Color> myColor) {
            Color color = Colors.blue;
            if (myColor.hasData) color = myColor.data;
            return Card(
              color: myColor.data.withOpacity(0.1),
              elevation: 0,
              child: ExpansionTile(
                expandedAlignment: Alignment.centerLeft,
                expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
                childrenPadding: EdgeInsets.symmetric(horizontal: 16.w),
                title: Text(
                  widget.data.title,
                  style: Theme.of(context).textTheme.bodyText1.copyWith(
                      decoration: widget.data.isDeleted
                          ? TextDecoration.lineThrough
                          : TextDecoration.none),
                ),
                leading: Icon(
                  widget.data.isDeleted
                      ? Icons.remove_circle_outline
                      : Icons.label,
                  color: color ?? MyColor.white,
                ),
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        widget.data.title,
                        style: Theme.of(context).textTheme.bodyText1.copyWith(
                            decoration: widget.data.isDeleted
                                ? TextDecoration.lineThrough
                                : TextDecoration.none),
                      ),
                      Spacer(),
                      Checkbox(
                        activeColor: color.withOpacity(0.15),
                        checkColor: color,
                        focusColor: color,
                        hoverColor: color,
                        value: widget.data.isDeleted,
                        onChanged: (vlaue) async {
                          widget.data.isDeleted = !widget.data.isDeleted;
                          await updateTodo(widget.data);
                          myState.call(() {});
                        },
                      ),
                      IconButton(
                          icon: Icon(
                            Icons.edit,
                            color: color,
                          ),
                          onPressed: () async {
                            var model = await Navigator.pushNamed(
                                context, "/addNew",
                                arguments: widget.data);
                            setState(() {
                              if (model != null) widget.data = model;
                            });
                          })
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      widget.data.description,
                      textAlign: TextAlign.start,
                      style: Theme.of(context).textTheme.caption.copyWith(
                          decoration: widget.data.isDeleted
                              ? TextDecoration.lineThrough
                              : TextDecoration.none),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> removeTodo(TodoDataModel todo) async {
    final database =
        await $FloorMyDatabase.databaseBuilder('app_database.db').build();
    TodoDao todoDao = database.todoDao;
    return await todoDao.removeTodoById(todo);
  }

  Future<void> updateTodo(TodoDataModel todo) async {
    final database =
        await $FloorMyDatabase.databaseBuilder('app_database.db').build();
    TodoDao todoDao = database.todoDao;
    return await todoDao.updateTodo(todo);
  }

  Future<Color> _getColor(int categoryId) async {
    if (categoryId == null) return null;
    final database =
        await $FloorMyDatabase.databaseBuilder('app_database.db').build();
    CategoryDao categoryDao = database.categoryDao;
    var response = await categoryDao.findCategoryById(categoryId);
    if (response == null) return null;
    return (await response.first).color;
  }
}
