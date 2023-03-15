import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatDimens {
  const ChatDimens._();

  static final double eight = 8.sp;
  static final double ten = 10.sp;
  static final double sixTeen = 16.sp;
  static final double twenty = 20.sp;
  static final double twentyFour = 24.sp;
  static final double thirtyTwo = 32.sp;

  static final double appBarHeight = 56.sp;
  static final double appBarElevation = 16.sp;

  static final Widget boxHeight8 = SizedBox(height: eight);
  static final Widget boxHeight16 = SizedBox(height: sixTeen);
  static final Widget boxHeight32 = SizedBox(height: thirtyTwo);
  static final Widget boxWidth8 = SizedBox(width: eight);
  static final Widget boxWidth16 = SizedBox(width: sixTeen);
  static final Widget boxWidth32 = SizedBox(width: thirtyTwo);

  static final EdgeInsets egdeInsets16 = EdgeInsets.all(sixTeen);
}
