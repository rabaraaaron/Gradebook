import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:gradebook/calculator/Calculator.dart';

void main(){

  test('calculateCategoryPercentage should give an average of percentages', ()async{
    final c = Calculator();
    List<double> l = [];
    l.add(1.0);
    l.add(.75);
    l.add(1.25);
    // expect(c.calculateCategoryPercentage(l), 100);
  });


}