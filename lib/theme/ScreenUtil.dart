import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Size screenSize;
double defaultScreenWidth = 750.0;
double defaultScreenHeight = 1334.0;
bool fontScaling = false;

double screenWidthDp = ScreenUtil.screenWidthDp;
double screenHeightDp = ScreenUtil.screenHeightDp;
double statusBarHeight = ScreenUtil.statusBarHeight;

final screen = ScreenUtil();
