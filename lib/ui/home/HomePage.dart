import 'package:flutter/material.dart';
import 'package:todo/core/database/MyDatabase.dart';
import 'package:todo/core/style/color.dart';
import 'package:todo/model/category/CategoryDao.dart';
import 'package:todo/model/todo/TodoDao.dart';
import 'package:todo/model/todo/TodoDataModel.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Material(color: Colors.transparent, child: Text("Todo app")),
        actions: [
          IconButton(
              icon: Hero(tag: "add new", child: Icon(Icons.add)),
              onPressed: () async {
                await Navigator.pushNamed(context, "/addNew");
                setState(() {});
              })
        ],
      ),
      body: FutureBuilder(
        future: _getTodos(),
        builder: (context, AsyncSnapshot<List<TodoDataModel>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            print("waiting");
            return Container();
          } else {
            if (snapshot.data.length == 0)
              return Center(
                child: Image.asset(
                  "assets/images/no_data.png",
                  fit: BoxFit.fitHeight,
                ),
              );
            else
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return StatefulBuilder(
                      builder: (context, myState) => Dismissible(
                        onDismissed: (direction) async {
                          await removeTodo(snapshot.data[index]);
                          snapshot.data.remove(snapshot.data[index]);
                          if (snapshot.data.length == 0) setState(() {});
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
                        key: Key(snapshot.data.toString()),
                        child: FutureBuilder(
                          future: _getColor(snapshot.data[index].categoryId),
                          builder: (context, AsyncSnapshot<Color> color) {
                            if (!color.hasData)
                              return Container();
                            else
                              return Card(
                                elevation: 0,
                                child: ExpansionTile(
                                  title: Text(
                                    snapshot.data[index].title,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .copyWith(
                                            decoration:
                                                snapshot.data[index].isDeleted
                                                    ? TextDecoration.lineThrough
                                                    : TextDecoration.none),
                                  ),
                                  leading: Icon(
                                    snapshot.data[index].isDeleted
                                        ? Icons.remove_circle_outline
                                        : Icons.label,
                                    color: color.data ?? MyColor.white,
                                  ),
                                  children: [
                                    ListTile(
                                      isThreeLine: false,
                                      title: Text(
                                        snapshot.data[index].title,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1
                                            .copyWith(
                                                decoration: snapshot
                                                        .data[index].isDeleted
                                                    ? TextDecoration.lineThrough
                                                    : TextDecoration.none),
                                      ),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Checkbox(
                                            activeColor:
                                                color.data.withOpacity(0.15),
                                            checkColor: color.data,
                                            focusColor: color.data,
                                            hoverColor: color.data,
                                            value:
                                                snapshot.data[index].isDeleted,
                                            onChanged: (vlaue) async {
                                              snapshot.data[index].isDeleted =
                                                  !snapshot
                                                      .data[index].isDeleted;
                                              await updateTodo(
                                                  snapshot.data[index]);
                                              myState.call(() {});
                                            },
                                          ),
                                          IconButton(
                                              icon: Icon(
                                                Icons.edit,
                                                color: color.data,
                                              ),
                                              onPressed: () async {
                                                await Navigator.pushNamed(
                                                    context, "/addNew",
                                                    arguments:
                                                        snapshot.data[index]);
                                                setState(() {});
                                              })
                                        ],
                                      ),
                                      subtitle: Text(
                                        snapshot.data[index].description,
                                        style: Theme.of(context)
                                            .textTheme
                                            .caption
                                            .copyWith(
                                                decoration: snapshot
                                                        .data[index].isDeleted
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
                  },
                ),
              );
          }
        },
      ),
    );
  }

  Future<List<TodoDataModel>> _getTodos() async {
    final database =
        await $FloorMyDatabase.databaseBuilder('app_database.db').build();
    TodoDao todoDao = database.todoDao;
    return await todoDao.findAllTodos();
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
