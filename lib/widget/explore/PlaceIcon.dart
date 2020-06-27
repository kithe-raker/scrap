import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
      padding: EdgeInsets.all(screenWidthDp / 42),
      decoration: BoxDecoration(
          color: Color(0xfff26A4FF),
          borderRadius: BorderRadius.circular(screenWidthDp)),
      child: SvgPicture.asset(
          'assets/placeIcon/${category.iconName(widget.categoryId)}',
          color: Colors.black87,
          fit: BoxFit.cover),
    );
  }
}

class Category {
  static const Map<String, String> pCategory = {
    '100': 'restaurant-icon.svg',
    '200': 'pubandbar-icon.svg',
    '300': 'travellocation-icon.svg',
    '350': 'forest-icon.svg',
    '400': 'vehicle-icon .svg',
    '500': 'town-icon.svg',
    '550': 'forest-icon.svg',
    '600': 'shopping-icon.svg',
    '700': 'building-icon.svg',
    '800': 'building-icon.svg',
    '900': 'building-icon.svg'
  };
  static const Map<String, String> category = {
    '550-5520': 'zoo-icon.svg',
    '700-7000': 'bank-icon.svg',
    '700-7010': 'bank-icon.svg',
    '700-7050': 'bank-icon.svg',
    '800-8100': 'government-icon.svg',
    '800-8200': 'school-icon.svg',
    '800-8300': 'library-icon.svg',
    '800-8600': 'gym-icon.svg',
    '900-9100': 'town-icon.svg'
  };

  String iconName(String categoryId) {
    var icon;
    icon = category[categoryId.substring(0, 8)];
    if (icon == null) icon = pCategory[categoryId.substring(0, 3)];
    return icon ?? 'building-icon.svg';
  }
}

final category = Category();
