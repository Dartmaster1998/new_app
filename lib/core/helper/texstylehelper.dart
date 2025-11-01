import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

abstract class Texstylehelper {

  static TextStyle small14blackw500 = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
    color: Colors.black,
    fontFamily: "Montserrat",
  );
   static TextStyle small14white500 = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
    color: Colors.white,
    fontFamily: "Montserrat",
  );
    static TextStyle medium20black700 = TextStyle(
    fontSize: 20.sp,
    fontWeight: FontWeight.w700,
    color: Colors.black,
    fontFamily: "Montserrat",
  );
    static TextStyle small8whitew500 = TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w500,
    color: Colors.white,
    fontFamily: "Montserrat",);
     static TextStyle small8blackw500 = TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w500,
    color: Colors.black,
    fontFamily: "Montserrat",);
    // ====== Заголовки ======
  static TextStyle medium20({Color color = Colors.black}) {
    return TextStyle(
      fontSize: 20.sp,
      fontWeight: FontWeight.w700,
      color: color,
    );
  }

  static TextStyle medium18({Color color = Colors.black}) {
    return TextStyle(
      fontSize: 18.sp,
      fontWeight: FontWeight.w600,
      color: color,
    );
  }

  // ====== Малый текст ======
  static TextStyle small14({Color color = Colors.black}) {
    return TextStyle(
      fontSize: 14.sp,
      fontWeight: FontWeight.w500,
      color: color,
    );
  }

  static TextStyle small12({Color color = Colors.black, required double fontSize}) {
    return TextStyle(
      fontSize: 12.sp,
      fontWeight: FontWeight.w400,
      color: color,
    );
  }

  // ====== Любые другие стили можно добавить ======
  static TextStyle bold16({Color color = Colors.black}) {
    return TextStyle(
      fontSize: 16.sp,
      fontWeight: FontWeight.bold,
      color: color,
    );
  }
}