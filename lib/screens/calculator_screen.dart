import 'package:flutter/material.dart';
import 'calculator_logic.dart';

void main() {
  runApp(const MyApp());
}

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

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  final logic = CalculatorLogic(); 
  String _display = '0';        // Current value shown on the main display
  List<String> _history = [];   // List to store calculation history

  // This function is called whenever a calculator button is pressed
  void _onButtonPressed(String value) {
    setState(() {
      logic.onButtonPress(value);

      // If user presses '=', store the completed equation + result in history
      if (value == '=') {
        _history.add(logic.equationWithResult);
      }

      // Update the main display with the latest value
      _display = logic.display;   
    });
  }

  @override
  Widget build(BuildContext context) {
    final buttons = [
      'C', '( )', '%', '÷',
      '7', '8', '9', '×',
      '4', '5', '6', '-',
      '1', '2', '3', '+',
      'CE', '0', '.', '=',
    ];

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // History display (scrollable, newest on top)
            Expanded(
              flex: 1,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                color: Colors.black,
                child: ListView.builder(
                  reverse: true, // show latest at top
                  itemCount: _history.length,
                  itemBuilder: (context, index) {
                    return Text(
                      _history[_history.length - 1 - index],
                      style: const TextStyle(color: Colors.grey, fontSize: 18),
                      textAlign: TextAlign.right,
                    );
                  },
                ),
              ),
            ),

            // Main calculator display
            Container(
              padding: const EdgeInsets.all(16),
              alignment: Alignment.bottomRight,
              color: Colors.black,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                reverse: true,
                child: Text(
                  _display,
                  style: const TextStyle(fontSize: 48, color: Colors.white),
                ),
              ),
            ),

            // Calculator buttons
            Container(
              width: double.infinity,
              height: 450,
              padding: const EdgeInsets.all(16),
              color: Colors.black,
              child: GridView.builder(
                itemCount: buttons.length,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 1,
                ),
                itemBuilder: (context, index) {
                  final buttonText = buttons[index];

                  // Determine button color
                  Color buttonColor;
                  if (buttonText == 'C' || buttonText == 'CE') {
                    buttonColor = const Color(0xFF963E3E);
                  } else if (['÷', '×', '-', '+'].contains(buttonText)) {
                    buttonColor = const Color(0xFF394734);
                  } else if (buttonText == '=') {
                    buttonColor = const Color(0xFF076544);
                  } else {
                    buttonColor = Colors.grey.shade900;
                  }

                  // Build each calculator button
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: buttonColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                    onPressed: () => _onButtonPressed(buttonText),
                    child: Text(
                      buttonText,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: buttonText == 'CE'
                            ? 20
                            : buttonText == '( )'
                                ? 22
                                : 35,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
