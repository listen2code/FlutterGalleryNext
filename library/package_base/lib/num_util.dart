import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';

class NumUtil {
  static bool compare({double? bigger, double? smaller}) {
    if (bigger != null && smaller != null) {
      try {
        Decimal biggerDouble = Decimal.parse(bigger.toString());
        Decimal smallerDouble = Decimal.parse(smaller.toString());
        return biggerDouble > smallerDouble;
      } catch (e) {
        debugPrint("compare error biggerDouble=$bigger smallerDouble=$smaller");
      }
    }
    return false;
  }
}
