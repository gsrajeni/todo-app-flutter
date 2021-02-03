import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:todo/core/database/MyDatabase.dart';
import 'package:todo/core/validator/validator.dart';
import 'package:todo/model/category/CategoryDao.dart';
import 'package:todo/model/category/CategoryDataModel.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class AddNewCategoryPage extends StatelessWidget {
  GlobalKey<FormState> _key = GlobalKey<FormState>();
  // create some values
  Color pickerColor = Color(0xff443a49);
  CategoryDataModel postModel = CategoryDataModel(color: Color(0xff443a49));
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Hero(tag: "add category", child: Material(color:Colors.transparent,child: Text("Add Category"))),
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
                CategoryDao categoryDao = database.categoryDao;
                await categoryDao.insertCategory(postModel);
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
                  onSaved: (value) => postModel.name = value,
                  decoration: InputDecoration(
                      hintText: "Input Category Name",
                      labelText: "Category Name",
                      border: OutlineInputBorder()),
                ),
                SizedBox(
                  height: 16.h,
                ),
                Text("Select a color for your category!"),
                ColorPicker(
                  pickerColor: pickerColor,
                  displayThumbColor: false,
                  paletteType: PaletteType.hsv,
                  onColorChanged:(color)=> postModel.color = color,
                  showLabel: false,
                  pickerAreaHeightPercent: 0.8,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
