import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Dimens {
  const Dimens._();

  static final double eight = 8.sp;
  static final double ten = 10.sp;
  static final double sixTeen = 16.sp;
  static final double thirtyTwo = 32.sp;

  static final Widget boxHeight8 = SizedBox(height: eight);
  static final Widget boxHeight16 = SizedBox(height: sixTeen);
  static final Widget boxHeight32 = SizedBox(height: thirtyTwo);

  static final EdgeInsets egdeInsets16 = EdgeInsets.all(sixTeen);
}
