import 'package:flutter/material.dart';
import 'package:scrap/widget/ScreenUtil.dart';

class PlaceIcon extends StatefulWidget {
  final String categoryId;
  PlaceIcon({@required this.categoryId});
  @override
  _PlaceIconState createState() => _PlaceIconState();
}

class _PlaceIconState extends State<PlaceIcon> {
  @override
  Widget build(BuildContext context) {
    screenutilInit(context);
    return Container(
        padding: EdgeInsets.all(screenWidthDp / 64),
        decoration: BoxDecoration(
            color: Color(0xfff26A4FF),
            borderRadius: BorderRadius.circular(screenWidthDp)),
        child: Icon(category.icon(widget.categoryId),
            size: s58, color: Colors.black87));
  }
}

class Category {
  static const Map<String, IconData> pCategory = {
    '100': Icons.fastfood,
    '200': Icons.place,
    '300': Icons.place,
    '350': Icons.nature_people,
    '400': Icons.drive_eta,
    '500': Icons.business,
    '550': Icons.place,
    '600': Icons.shopping_cart,
    '700': Icons.business,
    '800': Icons.place,
    '900': Icons.business
  };
  static const Map<String, IconData> category = {
    '800-8100': Icons.account_balance,
    '800-8200': Icons.school,
    '800-8300': Icons.local_library,
    '800-8600': Icons.fitness_center
  };

  IconData icon(String categoryId) {
    var icon;
    icon = category[categoryId.substring(0, 8)];
    if (icon == null) icon = pCategory[categoryId.substring(0, 3)];
    return icon;
  }
}

final category = Category();
