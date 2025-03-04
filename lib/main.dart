import 'package:flutter/material.dart';

void main() {
  runApp(CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.blue),
      home: CalculatorScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _output = '0';
  String _currentValue = '';
  String _operator = '';
  bool _clearNext = false;

  void _buttonPressed(String value) {
    setState(() {
      if ('0123456789.'.contains(value)) {
        if (_clearNext) {
          _currentValue = '';
          _clearNext = false;
        }
        _currentValue += value;
        _output = _currentValue;
      } else if ('+-x÷%'.contains(value)) {
        if (_currentValue.isNotEmpty && _operator.isEmpty) {
          _operator = value;
          _currentValue += value;
        } else if (_currentValue.isNotEmpty && _operator.isNotEmpty) {
          _calculate();
          _operator = value;
          _currentValue = _output + value;
        }
        _output = _currentValue;
      } else if (value == 'C') {
        _currentValue = '';
        _output = '0';
        _operator = '';
        _clearNext = false;
      } else if (value == '=') {
        _calculate();
      } else if (value == 'EFF') {
        if (_currentValue.isNotEmpty) {
          _currentValue = _currentValue.substring(0, _currentValue.length - 1);
          _output = _currentValue.isEmpty ? '0' : _currentValue;
        }
      }
    });
  }

  void _calculate() {
    List<String> values = _currentValue.split(_operator);
    if (values.length == 2) {
      double firstValue = double.tryParse(values[0]) ?? 0;
      double secondValue = double.tryParse(values[1]) ?? 0;
      switch (_operator) {
        case '+':
          _output = (firstValue + secondValue).toString();
          break;
        case '-':
          _output = (firstValue - secondValue).toString();
          break;
        case 'x':
          _output = (firstValue * secondValue).toString();
          break;
        case '÷':
          _output = secondValue != 0 ? (firstValue / secondValue).toString() : 'Erreur';
          break;
        case '%':
          _output = (firstValue % secondValue).toString();
          break;
      }
      _clearNext = true;
      _operator = '';
    }
  }

  Widget _buildButton(String value, {Color? color, Color? textColor}) {
    return Expanded(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? Colors.black,
          padding: EdgeInsets.all(20.0),
        ),
        child: Text(value, style: TextStyle(fontSize: 24.0, color: textColor ?? Colors.white)),
        onPressed: () => _buttonPressed(value),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.bottomLeft,
            padding: EdgeInsets.all(46.0),
            child: Text('Calculatrice', style: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold, color: Colors.white)),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.bottomRight,
              padding: EdgeInsets.all(24.0),
              color: Colors.black,
              child: Text(_output, style: TextStyle(fontSize: 48.0, color: Colors.white)),
            ),
          ),
          Column(
            children: <Widget>[
              Row(children: <Widget>[
                _buildButton('7'), _buildButton('8'), _buildButton('9'), _buildButton('÷', textColor: Colors.red)
              ]),
              Row(children: <Widget>[
                _buildButton('4'), _buildButton('5'), _buildButton('6'), _buildButton('x', textColor: Colors.red)
              ]),
              Row(children: <Widget>[
                _buildButton('1'), _buildButton('2'), _buildButton('3'), _buildButton('-', textColor: Colors.red)
              ]),
              Row(children: <Widget>[
                _buildButton('0'), _buildButton('.'), _buildButton('EFF',color: Colors.red, textColor: Colors.white), _buildButton('+', textColor: Colors.red)
              ]),
              Row(children: <Widget>[
                _buildButton('C'), _buildButton('=')
              ])
            ],
          ),
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(16.0),
            color: Colors.black,
            child: Text('Créé avec Flutter par FilsDev', style: TextStyle(fontSize: 16.0, color: Colors.white, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic)),
          ),
        ],
      ),
    );
  }
}
