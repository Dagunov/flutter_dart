import 'dart:math';

Function createPow(num power) => (num val) => pow(val, power);

num myPow(num val, {num power=2}) => pow(val, power);

class MyClass{
  static var firstCreatedObj;

  num a = 0;
  num b = 0;

  MyClass.onlyB(num this.b){
    firstCreatedObj ??= this;
  }

  factory MyClass.firstOrNext(bool first, {num val=0}){
    return first ? firstCreatedObj : MyClass.onlyB(val);
  }

  @override
  String toString() => 'MyClass: $a, $b';
}

mixin HasNumber{
  num _value = 0;

  num get value => _value;
  set value(val) => _value = val;
}

class EmptyClass with HasNumber{

}

void main() {
  var nullvar;
  dynamic a = 10;
  print('nullvar = $nullvar\na = $a\n');
  a ??= nullvar;
  print('a ??= nullvar;\na = $a\n');
  nullvar ??= a;
  print('nullvar ??= a;\nnullvar = $nullvar\n');
  nullvar = null;

  a = nullvar ?? 20;
  print('a = nullvar ?? 20;\na = $a\n');

  // lambdas
  print('lambdas\n');
  var sqr = (n) => pow(n, 2);
  print('4 squared is ${sqr(4)}\n');
  var pow3 = createPow(3);
  var sqrt = createPow(0.5);
  print('4 cubed is ${pow3(4)}\n');
  print('root of 4 is ${sqrt(4)}\n');

  // def parameters
  print('def parameters\n');
  print('5 squared is ${myPow(5)}\n');
  print('5 cubed is ${myPow(5, power: 3)}\n');

  // class constructors
  print('class constructors\n');
  var obj1 = MyClass.onlyB(4.01);
  print('MyClass.onlyB(4.01);\n$obj1\n');
  var obj2 = MyClass.onlyB(6.02);
  print('MyClass.onlyB(6.02);\n$obj2\n');
  var obj3 = MyClass.firstOrNext(true);
  print('MyClass.firstOrNext(true);\n$obj3\n');

  // mixin
  print('mixin\n');
  var empty = EmptyClass();
  empty.value = 7.1;
  print('empty.value = 7.1;\nempty.value = ${empty.value}\n');

  // return;
  // assert
  print('assert');
  // assert(obj1 is int);
  print('after assert\n');

  // collections
  print('collections\n');
  var list1 = <int>[1, 2, 3];
  var list2 = [0.1, 0.5, 0.7, ...list1];
  print('list2 = $list2\n');
  var set1 = <int>{0, 1, 2, 3, 4};
  var set2 = <int>{10, 9, 8, 7};
  set2.addAll(set1);
  print('set2 = $set2\n');
  set2.add(0);
  print('after add: set2 = $set2\n');
  var map = {1: 2, 2: 4, 3: 9};
  map[4] = 16;
  print('map[4] = ${map[4]}\n');
  for(var e in map.entries){
    print('for loop: $e');
  }
  print('');

  print('are all elements of list2 less than 2? ${list2.every((e) => e < 2)}');
  print('are all elements of list2 less than 5? ${list2.every((e) => e < 5)}');
}