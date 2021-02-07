
import 'package:flutter/material.dart';
import 'package:todo/core/style/color.dart';
import 'package:todo/core/style/styles.dart';
import 'package:todo/model/todo/TodoDataModel.dart';
import 'package:timelines/timelines.dart';
import 'package:intl/intl.dart';
import 'TodoCard.dart';


class HomeBody extends StatefulWidget {
  List<TodoDataModel> dataList;
  HomeBody(this.dataList);
  @override
  _HomeBodyState createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: StatefulBuilder(
        builder:(context, myState)=> Timeline.tileBuilder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          builder: TimelineTileBuilder(
              indicatorBuilder: (context, index) => Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    DateFormat("hh:mm a")
                        .format(widget.dataList[index].timestamp),
                    style: MyStyle.captionStyle(
                        MyColor.secondaryColor),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              endConnectorBuilder: (d, p) => DecoratedLineConnector(
                thickness: 3,
                decoration: BoxDecoration(
                    color: MyColor.primaryColor,
                    shape: BoxShape.rectangle),
              ),
              startConnectorBuilder: (d, p) => DecoratedLineConnector(
                thickness: 3,
                decoration: BoxDecoration(
                    color: MyColor.primaryColor,
                    shape: BoxShape.rectangle),
              ),
              itemCount: widget.dataList.length,
              nodePositionBuilder: (d, p) => 0.02,
              contentsAlign: ContentsAlign.basic,
              indicatorPositionBuilder: (d, p) => .5,
              contentsBuilder: (context, index) {
                return TodoCard(widget.dataList[index],

                        (TodoDataModel data) {
                      widget.dataList.remove(data);
                      myState(() {
                        widget.dataList.remove(data);
                      });
                    });
              }),
        ),
      ),
    );
  }

}
