import 'dart:math';
import 'package:flutter/material.dart';



void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hex Calculator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Hex Calculator'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

// App body
class _MyHomePageState extends State<MyHomePage> {
  String _regM = "0";
  String _op1 = "0";
  String _op2 = "0";
  String _res = "0";
  String _operator = "";
  int _currentOperand = 1;
  int _signExtend = 0;

  void _keyPressed(String key) {
    setState(() {
      if (_currentOperand == 1) {
        _op1 += key;
      } else {
        _op2 += key;
      }
    });
  }

  // ******** Generic API ********

  /**  Perform a backspace on the given variable value
   *
   *  @param  str   Input string
   *
   *  @return       Input string without the last character. If the string is empty, return "0"
   */
  String _removeLastChar(String str)  {
    return (str.length == 1) ? "0" : str.substring(0, str.length - 1);
  }

  /** Insert spaces between groups of 4 hex digits
   *
   * @param s1    Input string (assumed to be compact) 
   *
   * @return      Processed string
   */
  String _asciiInsertSeparators(String s1)  {
    String ret = "";
    int len = 0;

    do {
      len = s1.length;

      if (ret.length > 0) {
        ret = " " + ret;
      }
      ret = s1.substring(len - 4) + ret;
      s1 = s1.substring(len - 4);
    } while (len > 4);

    len = 4 - len;
    while (len > 0) {
      ret = "0" + ret;
      len--;
    }

    return ret;
  }

  /** Shift nibbles to the left
   *
   * @param s1      Input value
   * @param shifts  Number of null nibbles to store on the left
   *
   * @return        Processed string
   */
  String _asciiNibbleShiftLeft(String s1, int shifts)  {
    while (shifts > 0)  {
      s1 += "0";
      shifts--;
    }
    return s1;
  }

  /** Shift an arbitrary number of bits to the left. When shifts is beyond 4,
   *  the nibbles are added 1 at a time to speed up the process.
   *
   * @param s1      Input value
   * @param shifts  Number of bits to shift to the left
   *
   * @return        Processed value
   */
  String _asciiLogicalShiftLeft(String s1, int myShifts)  {
    String ret = "";
    int nibbles = myShifts ~/ 4;
    const int myRadix = 16;

    if (s1 == "") {
      s1 = "0";
    }

    myShifts -= nibbles * 4;
    if (myShifts > 0)  {
      int i = s1.length - 1;
      int carry = 0;
      int factor = 1 << myShifts;

      while ((i >= 0) && (carry > 0))  {
        int digit = (i >= 0) ? int.parse(s1[i], radix: myRadix) * factor : 0;
        carry = digit ~/ myRadix;
        digit -= carry * myRadix;
        ret = digit.toRadixString(myRadix) + ret;
        i--;
      }
    }

    while (nibbles > 0) {
      ret += "0";
      nibbles--;
    }

    return ret;
  }

  String _asciiBinaryTrimLeft(String str) {
    int i = 0;
    int len = str.length;
    String ret = "";

    while ((i < len) && (str[i] == '0')) {
      i++;
    }
    ret = str.substring(i);

    return ret;
  }

  int _asciiCompare(String s1, String s2)  {
    String str1 = _asciiBinaryTrimLeft(s1);
    String str2 = _asciiBinaryTrimLeft(s2);
    const int myRadix = 16;

    if (str1.length > str2.length)  {
      return 1;
    } else if (str1.length < str2.length)  {
      return -1;
    }

    int len = str1.length;
    int i = 0;

    while (i < len) {
      int digit1 = int.parse(str1[i], radix: myRadix);
      int digit2 = int.parse(str2[i], radix: myRadix);

      if (digit1 > digit2)  {
        return 1;
      } else if (digit1 < digit2) {
        return -1;
      }
    }
    return 0;
  }

  /** Multiply an arbitrary number by a nibble-wide factor. This method
   * prepares the implementation of a multiply of arbitrary length.
   *
   * @param s1      Input value
   * @param factor  Multiplying factor
   *
   * @return        Processed value
   */
  String _asciiNibbleMult(String s1, int factor, int nibbleShifts)  {
    int carry = 0;
    int i = s1.length - 1;
    String ret = "";
    const int myRadix = 16;

    if (s1 == "")  {
      s1 = "0";
    }

    while ((i >= 0) || (carry > 0))  {
      int digit = (i >= 0) ? int.parse(s1[i], radix: myRadix) * factor : 0;
      int res = digit * factor + carry;

      carry = res ~/ myRadix;
      res -= carry * myRadix;
      ret = res.toRadixString(myRadix) + ret;
      i--;
    }

    while (nibbleShifts > 0)  {
      ret += "0";
      nibbleShifts--;
    }

    return ret;
  }

  String _asciiAdd(String s1, String s2) {
    String ret = "";
    int idx1 = s1.length - 1;
    int idx2 = s2.length - 1;
    int carry = 0;
    const int myRadix = 16;

    while ((idx1 >= 0) || (idx2 >= 0) || (carry > 0)) {
      int digit1 = (idx1 >= 0) ? int.parse(s1[idx1], radix: myRadix) : 0;
      int digit2 = (idx2 >= 0) ? int.parse(s2[idx2], radix: myRadix) : 0;
      int mySum = digit1 + digit2 + carry;

      carry = mySum ~/ myRadix;
      ret = mySum.toRadixString(myRadix) + ret;
      idx1--;
      idx2--;
    }

    if (ret == "")  {
      ret = "0";
    }

    return ret;
  }

  String _asciiAnd(String s1, String s2)  {
    String ret = "";
    int idx1 = s1.length - 1;
    int idx2 = s2.length - 1;
    const int myRadix = 16;

    while ((idx1 >= 0) || (idx2 >= 0))  {
      int digit1 = (idx1 >= 0) ? int.parse(s1[idx1], radix: myRadix) : 0;
      int digit2 = (idx2 >= 0) ? int.parse(s2[idx2], radix: myRadix) : 0;

      ret = (digit1 & digit2).toRadixString(myRadix) + ret;
    }

    return ret;
  }

  String _asciiOr(String s1, String s2)  {
    String ret = "";
    int idx1 = s1.length - 1;
    int idx2 = s2.length - 1;
    const int myRadix = 16;

    while ((idx1 >= 0) || (idx2 >= 0))  {
      int digit1 = (idx1 >= 0) ? int.parse(s1[idx1], radix: myRadix) : 0;
      int digit2 = (idx2 >= 0) ? int.parse(s2[idx2], radix: myRadix) : 0;

      ret = (digit1 | digit2).toRadixString(myRadix) + ret;
    }

    return ret;
  }

  String _asciiXor(String s1, String s2)  {
    String ret = "";
    int idx1 = s1.length - 1;
    int idx2 = s2.length - 1;
    const int myRadix = 16;

    while ((idx1 >= 0) || (idx2 >= 0))  {
      int digit1 = (idx1 >= 0) ? int.parse(s1[idx1], radix: myRadix) : 0;
      int digit2 = (idx2 >= 0) ? int.parse(s2[idx2], radix: myRadix) : 0;

      ret = (digit1 ^ digit2).toRadixString(myRadix) + ret;
    }

    return ret;
  }

  String _asciiNot(String s1)  {
    String ret = "";
    int idx1 = s1.length - 1;
    const int myRadix = 16;

    while (idx1 >= 0)  {
      int digit1 = (idx1 >= 0) ? int.parse(s1[idx1], radix: myRadix) : 0;

      ret = ((~digit1) & 0xff).toRadixString(myRadix) + ret;
    }

    return ret;
  }



  // ******** App objects maintenance ********

  /** Register operator and switch operand for the input
   *
   * @param op    OPerator to store
  */
  void _storeOperator(String op) {
    _operator = op;
    _currentOperand = 2;
  }

  // Reset the operands - DELETE key
  void _clearReg() {
    setState(() {
      _op1 = "0";
      _op2 = "0";
    });
  }

  void _memAdd() {}

  void _memMinus() {}

  void _memClear() {
    setState(() {
      _regM = "0";
    });
  }

  void _memRecall() {}

  void _keyPressed0() {
    _keyPressed("0");
  }

  void _keyPressed1() {
    _keyPressed("1");
  }

  void _keyPressed2() {
    _keyPressed("2");
  }

  void _keyPressed3() {
    _keyPressed("3");
  }

  void _keyPressed4() {
    _keyPressed("4");
  }

  void _keyPressed5() {
    _keyPressed("5");
  }

  void _keyPressed6() {
    _keyPressed("6");
  }

  void _keyPressed7() {
    _keyPressed("7");
  }

  void _keyPressed8() {
    _keyPressed("8");
  }

  void _keyPressed9() {
    _keyPressed("9");
  }

  void _keyPressedA() {
    _keyPressed("A");
  }

  void _keyPressedB() {
    _keyPressed("B");
  }

  void _keyPressedC() {
    _keyPressed("C");
  }

  void _keyPressedD() {
    _keyPressed("D");
  }

  void _keyPressedE() {
    _keyPressed("E");
  }

  void _keyPressedF() {
    _keyPressed("F");
  }

  void _backSpace() {
    setState(() {
      if (_currentOperand == 1) {
        _op1 = _removeLastChar(_op1);
      } else {
        _op2 = _removeLastChar(_op2);
      }
    });
  }

  void _keyPressedPlus() {
    _storeOperator("+");
  }

  void _keyPressedMinus() {
    _storeOperator("-");
  }

  void _keyPressedMult() {
    _storeOperator("*");
  }

  void _keyPressedDivide() {
    _storeOperator("/");
  }

  void _keyPressedAnd() {
    _storeOperator("&");
  }

  void _keyPressedOr() {
    _storeOperator("|");
  }

  void _keyPressedXor() {
    _storeOperator("^");
  }

  void _keyPressedNot() {
    _storeOperator("!");
  }

  void _keyPressedDel() {
    _clearReg();
  }

  void _keyPressedMPlus() {
    _memAdd();
  }

  void _keyPressedMMinus() {
    _memMinus();
  }

  void _keyPressedMc() {
    _memClear();
  }

  void _keyPressedMr() {
    _memRecall();
  }

  void _keyPressedDot() {
    _keyPressed(".");
  }

  void _keyPressedEquals() {
    _storeOperator("=");
  }

  void _keyPressedDummy() {}

  Widget _genButtonContainer(String label, void Function() cb) {
    return SizedBox(
      height: 50,
      child: TextButton(
        style: const ButtonStyle(
          backgroundColor: MaterialStatePropertyAll(Colors.grey),
          padding: MaterialStatePropertyAll(EdgeInsets.all(5)),
        ),
        onPressed: cb,
        child: Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }

  Wigdget _genDisplayLine(const String label, String varValue) {
    return DefaultTextStyle(
        style: defaultTS,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              label,
              Expanded(
                child: Text(
                  varValue,
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    const defaultTS = TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    );

    return Scaffold(
      backgroundColor: const Color.fromARGB(0xff, 0x80, 0xc0, 0xe0),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _genDisplayLine(const Text("M"), '$_regM'),
            _genDisplayLine(const Text("Op1"), '$_op1'),
            _genDisplayLine(const Text("Op2"), '$_op2'),
            _genDisplayLine(const Text("Result"), '$_res'),
            //
            const Expanded(
              child: Text(" "),
            ),
            Row(
              children: [
                Expanded(child: _genButtonContainer("A", _keyPressedA)),
                Expanded(child: _genButtonContainer("B", _keyPressedB)),
                Expanded(child: _genButtonContainer("C", _keyPressedC)),
                Expanded(child: _genButtonContainer("D", _keyPressedD)),
                Expanded(child: _genButtonContainer("E", _keyPressedE)),
                Expanded(child: _genButtonContainer("F", _keyPressedF)),
                Expanded(child: _genButtonContainer("BS", _backSpace)),
              ],
            ),
            Row(
              children: [
                Expanded(child: _genButtonContainer("7", _keyPressed7)),
                Expanded(child: _genButtonContainer("8", _keyPressed8)),
                Expanded(child: _genButtonContainer("9", _keyPressed9)),
                Expanded(child: _genButtonContainer("+", _keyPressedPlus)),
                Expanded(child: _genButtonContainer("AND", _keyPressedAnd)),
                Expanded(child: _genButtonContainer("M+", _keyPressedMPlus)),
                Expanded(child: _genButtonContainer("DEL", _keyPressedDel)),
              ],
            ),
            Row(
              children: [
                Expanded(child: _genButtonContainer("4", _keyPressed4)),
                Expanded(child: _genButtonContainer("5", _keyPressed5)),
                Expanded(child: _genButtonContainer("6", _keyPressed6)),
                Expanded(child: _genButtonContainer("-", _keyPressedMinus)),
                Expanded(child: _genButtonContainer("OR", _keyPressedOr)),
                Expanded(child: _genButtonContainer("M-", _keyPressedMMinus)),
                Expanded(child: _genButtonContainer(" ", _keyPressedDummy)),
              ],
            ),
            Row(
              children: [
                Expanded(child: _genButtonContainer("1", _keyPressed1)),
                Expanded(child: _genButtonContainer("2", _keyPressed2)),
                Expanded(child: _genButtonContainer("3", _keyPressed3)),
                Expanded(child: _genButtonContainer("*", _keyPressedMult)),
                Expanded(child: _genButtonContainer("XOR", _keyPressedXor)),
                Expanded(child: _genButtonContainer("MR", _keyPressedMr)),
                Expanded(child: _genButtonContainer(" ", _keyPressedDummy)),
              ],
            ),
            Row(
              children: [
                Expanded(child: _genButtonContainer("0", _keyPressed0)),
                Expanded(child: _genButtonContainer(".", _keyPressedDot)),
                Expanded(child: _genButtonContainer("=", _keyPressedEquals)),
                Expanded(child: _genButtonContainer("/", _keyPressedDivide)),
                Expanded(child: _genButtonContainer("NOT", _keyPressedNot)),
                Expanded(child: _genButtonContainer("MC", _keyPressedMc)),
                Expanded(child: _genButtonContainer(" ", _keyPressedDummy)),
              ],
            ),
          ],
        ),
      ),
/*
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
*/
    );
  }
}
