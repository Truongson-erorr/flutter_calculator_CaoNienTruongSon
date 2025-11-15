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
  String _display = '0';

  void _onButtonPressed(String value) {
    setState(() {
      logic.onButtonPress(value);
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
            Expanded(
              flex: 1,
              child: Container(
                padding: const EdgeInsets.all(16),
                alignment: Alignment.bottomRight,
                color: Colors.black,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  reverse: true, // để số mới hiển thị bên phải
                  child: Text(
                    _display,
                    style: const TextStyle(
                      fontSize: 48,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),

            Container(
              width: 440,
              height: 490,
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

                  Color buttonColor;
                  if (buttonText == 'C') {
                    buttonColor = const Color(0xFF963E3E);
                  } else if (['÷', '×', '-', '+'].contains(buttonText)) {
                    buttonColor = const Color(0xFF394734);
                  } else if (buttonText == '=') {
                    buttonColor = const Color(0xFF076544);
                  } else {
                    buttonColor = Colors.grey.shade900;
                  }

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
                        fontSize: buttonText == 'CE' ? 28 : 35, 
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
