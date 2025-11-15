import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

class CalculatorLogic {
  String display = "0";
  String _equation = "";
  bool _justCalculated = false;

  void onButtonPress(String btn) {
    if (_isNumber(btn) || btn == ".") {
      _inputNumber(btn);
    } else if (_isOperation(btn)) {
      _inputOperation(btn);
    } else {
      switch (btn) {
        case "=":
          _calculate();
          return;
        case "C":
          _clearAll();
          return;
        case "CE":
          _clearEntry();
          return;
        case "±":
          _toggleSign();
          return;
        case "%":
          _percent();
          return;
      }
    }
  }

  // Nhập số
  void _inputNumber(String number) {
    if (_justCalculated) {
      _equation = "";
      _justCalculated = false;
    }

    if (_equation.isEmpty && number == ".") {
      _equation = "0.";
    } else if (_equation.endsWith(".") && number == ".") {
      return; // tránh 2 dấu .
    } else {
      _equation += number;
    }
    display = _equation;
  }

  // Nhập phép toán
  void _inputOperation(String op) {
    if (_equation.isEmpty) {
      if (op == "-") {
        _equation = "-";
        display = _equation;
      }
      return;
    }

    String lastChar = _equation[_equation.length - 1];

    if (_isOperation(lastChar)) {
      _equation = _equation.substring(0, _equation.length - 1) + op;
    } else {
      _equation += op;
    }

    display = _equation;
    _justCalculated = false;
  }

  void _calculate() {
    if (_equation.isEmpty) return;

    try {
      String exp = _equation.replaceAll('×', '*').replaceAll('÷', '/');

      // Loại bỏ phép toán cuối nếu có
      while (exp.isNotEmpty && _isOperation(exp[exp.length - 1])) {
        exp = exp.substring(0, exp.length - 1);
      }

      Parser p = Parser();
      Expression expression = p.parse(exp);
      ContextModel cm = ContextModel();
      double eval = expression.evaluate(EvaluationType.REAL, cm);

      if (eval.isInfinite || eval.isNaN) {
        display = "Error";
        _equation = "";
      } else {
        display = _removeTrailingZero(eval);
        _equation = display;
      }

      _justCalculated = true;
    } catch (e) {
      display = "Error";
      _equation = "";
      _justCalculated = true;
    }
  }

  void _clearAll() {
    display = "0";
    _equation = "";
    _justCalculated = false;
  }

  void _clearEntry() {
    if (_equation.isEmpty) return;

    _equation = _equation.substring(0, _equation.length - 1);
    display = _equation.isEmpty ? "0" : _equation;
  }

  void _toggleSign() {
    if (_equation.isEmpty) return;

    RegExp regex = RegExp(r'(-?\d+\.?\d*)$');
    Match? match = regex.firstMatch(_equation);
    if (match != null) {
      String number = match.group(0)!;
      if (number.startsWith("-")) {
        _equation = _equation.replaceFirst(number, number.substring(1));
      } else {
        _equation = _equation.replaceFirst(number, "-$number");
      }
      display = _equation;
    }
  }

  void _percent() {
    if (_equation.isEmpty) return;

    RegExp regex = RegExp(r'(\d+\.?\d*)$');
    Match? match = regex.firstMatch(_equation);
    if (match != null) {
      double number = double.parse(match.group(0)!);
      number = number / 100;
      _equation =
          _equation.replaceFirst(match.group(0)!, _removeTrailingZero(number));
      display = _equation;
    }
  }

  bool _isNumber(String val) => RegExp(r'^[0-9]$').hasMatch(val);

  bool _isOperation(String val) => ["+", "-", "×", "÷"].contains(val);

  String _removeTrailingZero(double val) {
    if (val == val.toInt()) return val.toInt().toString();
    return val.toString();
  }
}
