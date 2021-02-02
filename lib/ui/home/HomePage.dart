import 'package:flutter/material.dart';
import 'package:todo/core/database/MyDatabase.dart';
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
          if (snapshot.connectionState == ConnectionState.waiting)
            return Text("Loading");
          else if (snapshot.hasData) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return StatefulBuilder(
                    builder: (context, myState) => Dismissible(
                      onDismissed: (direction) async {
                        await removeTodo(snapshot.data[index]);
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
                      child: Card(
                        color: snapshot.data[index].isDeleted
                            ? Colors.grey.shade100
                            : Colors.white,
                        elevation: 0,
                        child: ExpansionTile(
                          title: Text(
                            snapshot.data[index].title,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .copyWith(
                                    decoration: snapshot.data[index].isDeleted
                                        ? TextDecoration.lineThrough
                                        : TextDecoration.none),
                          ),
                          leading: Icon(snapshot.data[index].isDeleted
                              ? Icons.remove_circle_outline
                              : Icons.label),
                          children: [
                            ListTile(
                              isThreeLine: false,
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
                              trailing: Checkbox(
                                value: snapshot.data[index].isDeleted,
                                onChanged: (vlaue) {
                                  myState.call(() {
                                    snapshot.data[index].isDeleted =
                                        !snapshot.data[index].isDeleted;
                                  });
                                },
                              ),
                              subtitle: Text(
                                snapshot.data[index].description,
                                style: Theme.of(context)
                                    .textTheme
                                    .caption
                                    .copyWith(
                                        decoration:
                                            snapshot.data[index].isDeleted
                                                ? TextDecoration.lineThrough
                                                : TextDecoration.none),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          } else
            return Text("No data found");
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
}
