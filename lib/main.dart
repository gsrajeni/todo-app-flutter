// import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'core/route/routes.dart';
import 'core/style/color.dart';
import 'core/style/theme.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(360, 690),
      allowFontScaling: false,
      child: MaterialApp(
      color: MyColor.primaryColor,
      onGenerateRoute: Routes.generateRoute,
      initialRoute: "/",
      theme: MyTheme.getMyTheme(context),
      debugShowCheckedModeBanner: false,
    )
    );

  }

}
