import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

class CalculatorLogic {
  String display = "0"; // Current text shown on the calculator screen
  String _equation = ""; // Full expression being typed
  bool _justCalculated = false; // True if the last button pressed was "="
  String _lastExpression = ""; // Stores last full expression before calculation

  // Return last expression and its result as a string
  String get equationWithResult => "$_lastExpression = $display";

  // Main function: handle any button press
  void onButtonPress(String btn) {
    if (_isNumber(btn) || btn == ".") {
      _inputNumber(btn); // If number or decimal
    } else if (_isOperation(btn)) {
      _inputOperation(btn); // If operation + - × ÷
    } else {
      switch (btn) {
        case "=":
          _calculate(); // Calculate result
          return;
        case "C":
          _clear(); // Clear all
          return;
        case "CE":
          _clearEnd(); // Delete last character
          return;
        case "±":
          _toggleSign(); // Change sign of last number
          break;
        case "%":
          _percent(); // Convert last number to percentage
          break;
        case "( )":
          _brackets(); // Add brackets
          break;
      }
    }
  }

  // Add number or decimal point
  void _inputNumber(String number) {
    if (_justCalculated) {
      _equation = ""; // Reset after calculation
      _justCalculated = false;
    }

    if (_equation.isEmpty && number == ".") {
      _equation = "0."; // Start with 0. if user types "."
    } else if (_equation.endsWith(".") && number == ".") {
      return; // Prevent double "."
    } else {
      _equation += number; // Add number to expression
    }

    display = _equation; // Update display
  }

  // Add operation + - × ÷
  void _inputOperation(String op) {
    if (_equation.isEmpty) return;

    // Replace last operator if user presses two in a row
    if (_isOperation(_equation[_equation.length - 1])) {
      _equation = _equation.substring(0, _equation.length - 1) + op;
    } else {
      _equation += op;
    }
    display = _equation;
    _justCalculated = false;
  }

  // Calculate current expression
  void _calculate() {
    if (_equation.isEmpty) return;
    _lastExpression = _equation; // Store expression for history

    try {
      // Replace symbols for parser
      String exp = _equation.replaceAll('×', '*').replaceAll('÷', '/');
      Parser p = Parser();
      Expression expression = p.parse(exp);
      ContextModel cm = ContextModel();
      double result = expression.evaluate(EvaluationType.REAL, cm);

      display = _removeTrailingZero(result); // Remove .0 if needed
      _equation = display;
      _justCalculated = true; // Mark calculation done
    } catch (e) {
      display = "Error"; // Show error if calculation fails
      _equation = "";
      _justCalculated = true;
    }
  }

  // Clear all
  void _clear() {
    display = "0";
    _equation = "";
    _justCalculated = false;
  }

  // Delete last character (CE)
  void _clearEnd() {
    if (_equation.isNotEmpty) {
      _equation = _equation.substring(0, _equation.length - 1);
      display = _equation.isEmpty ? "0" : _equation;
    } else {
      display = "0";
    }
  }

  // Change sign of last number
  void _toggleSign() {
    if (_equation.isEmpty) return;
    RegExp regex = RegExp(r'(-?\d+\.?\d*)$'); // Find last number
    Match? match = regex.firstMatch(_equation);
    if (match != null) {
      String number = match.group(0)!;
      if (number.startsWith("-")) {
        _equation = _equation.replaceFirst(number, number.substring(1));
      } else {
        _equation = _equation.replaceFirst(number, "-$number");
      }
    }
    display = _equation;
  }

  // Convert last number to percentage
  void _percent() {
    if (_equation.isEmpty) return;
    RegExp regex = RegExp(r'(\d+\.?\d*)$'); // Find last number
    Match? match = regex.firstMatch(_equation);
    if (match != null) {
      double number = double.parse(match.group(0)!);
      number = number / 100;
      _equation =
          _equation.replaceFirst(match.group(0)!, _removeTrailingZero(number));
      display = _equation;
    }
  }

  // Add brackets ()
  void _brackets() {
    _equation += "()";
    display = _equation;
  }

  // Check if character is number 0-9
  bool _isNumber(String val) => RegExp(r'^[0-9]$').hasMatch(val);

  // Check if character is operation + - × ÷
  bool _isOperation(String val) => ["+", "-", "×", "÷"].contains(val);

  // Remove trailing .0 if number is integer
  String _removeTrailingZero(double val) {
    if (val == val.toInt()) return val.toInt().toString();
    return val.toString();
  }
}
