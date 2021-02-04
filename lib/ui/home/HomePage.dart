import 'package:flutter/material.dart';
import 'package:todo/core/database/MyDatabase.dart';
import 'package:todo/core/style/color.dart';
import 'package:todo/core/style/styles.dart';
import 'package:todo/model/category/CategoryDao.dart';
import 'package:todo/model/todo/TodoDao.dart';
import 'package:todo/model/todo/TodoDataModel.dart';
import 'package:todo/ui/addNew/AddNewPage.dart';
import 'package:todo/ui/home/widgets/HomeBody.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:intl/intl.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:badges/badges.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime _currentDate =
      DateTime.parse(DateFormat("yyyy-MM-dd").format(DateTime.now()));
  List<TodoDataModel> dataList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Material(color: Colors.transparent, child: Text("Todo app")),
        actions: [
          IconButton(
              icon: Hero(tag: "add new", child: Icon(Icons.add)),
              onPressed: () async {
                var response = await Navigator.pushNamed(context, "/addNew");
                if (response != null) setState(() {});
              })
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: true,
            stretch: true,
            floating: true,
            pinned: true,
            toolbarHeight: 0,
            expandedHeight: 360.h,
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.parallax,
              background: CalendarCarousel<Event>(
                onDayPressed: (DateTime date, List<Event> events) {
                  this.setState(() => _currentDate = date);
                },
                weekendTextStyle: TextStyle(
                  color: Colors.red,
                ),
                onCalendarChanged: (DateTime dateTime){
                  setState(() {
                    _currentDate = dateTime;
                  });
                },
                thisMonthDayBorderColor: Colors.grey,
                weekFormat: false,
                dayButtonColor: MyColor.white,
                selectedDateTime: _currentDate,
                daysHaveCircularBorder: true,
                selectedDayButtonColor: MyColor.blue,
                todayButtonColor: MyColor.primaryColor,
                customDayBuilder: (
                  bool isSelectable,
                  int index,
                  bool isSelectedDay,
                  bool isToday,
                  bool isPrevMonthDay,
                  TextStyle textStyle,
                  bool isNextMonthDay,
                  bool isThisMonthDay,
                  DateTime day,
                ) {
                  return FutureBuilder(
                    future: _getTodos(day),
                    builder:
                        (context, AsyncSnapshot<List<TodoDataModel>> snapshot) {
                      return Center(
                        child: Badge(
                          alignment: Alignment.bottomLeft,
                          showBadge: snapshot?.data?.length == 0 ? false : true,
                          badgeContent: Text("${snapshot?.data?.length?? "..."}", style: MyStyle.captionStyle(MyColor.white),),
                          child: Text(DateFormat("dd").format(day)),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
          SliverList(
              delegate: SliverChildListDelegate([
            FutureBuilder(
              future: _getTodos(_currentDate),
              builder:
                  (context, AsyncSnapshot<List<TodoDataModel>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container();
                } else {
                  if (snapshot.data.length == 0) {
                    return Center(
                      child: Image.asset(
                        "assets/images/no_data.png",
                        fit: BoxFit.fitHeight,
                      ),
                    );
                  } else {
                    return HomeBody(snapshot.data);
                  }
                }
              },
            ),
          ])),
        ],
      ),
    );
  }

  Future<List<TodoDataModel>> _getTodos(DateTime selectedDate) async {
    print(selectedDate.toString());
    final database =
        await $FloorMyDatabase.databaseBuilder('app_database.db').build();
    TodoDao todoDao = database.todoDao;
    return await todoDao.findAllTodosByDate(selectedDate.millisecondsSinceEpoch,
        selectedDate.add(Duration(days: 1)).millisecondsSinceEpoch);
  }
}
