import 'package:flutter/material.dart';
import 'calculator_logic.dart';

void main() {
  runApp(const MyApp());
}

/// Main App
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calculator App',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
      ),
      home: const CalculatorScreen(),
    );
  }
}

/// Calculator Screen
class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  final logic = CalculatorLogic(); 
  String _display = '0';
  final List<String> _history = [];

  static const List<String> buttons = [
    'C', '( )', '%', '÷',
    '7', '8', '9', '×',
    '4', '5', '6', '-',
    '1', '2', '3', '+',
    '+/-', '0', '.', '=',   
  ];

  /// Handle button press
  void _onButtonPressed(String value) {
    setState(() {
      logic.onButtonPress(value);

      // Store completed equation + result in history
      if (value == '=') {
        _history.add(logic.equationWithResult);
      }

      // Update main display
      _display = logic.display;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1C),
      body: SafeArea(
        child: Column(
          children: [
            /// History section
            Expanded(
              flex: 1,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: ListView(
                  reverse: true,
                  children: _history.reversed
                      .map((item) => Text(
                            item,
                            textAlign: TextAlign.right,
                            style: const TextStyle(color: Colors.grey, fontSize: 18),
                          ))
                      .toList(),
                ),
              ),
            ),

            /// Main Display
            Container(
              padding: const EdgeInsets.all(16),
              alignment: Alignment.bottomRight,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                reverse: true,
                child: Text(
                  _display,
                  style: const TextStyle(fontSize: 48, color: Colors.white),
                ),
              ),
            ),

            /// Buttons
            Container(
              width: 440,
              height: 445,
              padding: const EdgeInsets.all(16),
              child: GridView.builder(
                itemCount: buttons.length,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                ),
                itemBuilder: (context, index) {
                  final btn = buttons[index];
                  return _buildButton(btn);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build each calculator button
  Widget _buildButton(String text) {
    Color color;

    if (text == 'C') {
      color = const Color(0xFF963E3E);
    } else if (['÷', '×', '-', '+'].contains(text)) {
      color = const Color(0xFF394734);
    } else if (text == '=') {
      color = const Color(0xFF076544);
    } else {
      color = const Color(0xFF272727);
    }

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
        ),
        elevation: 0, // Remove default shadow
        shadowColor: Colors.transparent, // Ensure no shadow
      ),
      onPressed: () => _onButtonPressed(text),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: text == '+/-'
              ? 20
              : text == '( )'
                ? 27
                : 38,
          color: Colors.white,
        ),
      ),
    );
  }
}
