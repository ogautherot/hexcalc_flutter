//import 'dart:js';
//import 'dart:ui';

import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
//import 'package:flutter/painting.dart';
//import 'package:flutter/rendering.dart';
//mport 'package:flutter/widgets.dart';

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

class _MyHomePageState extends State<MyHomePage> {
  String _regM = "0";
  String _op1 = "0";
  String _op2 = "0";
  String _res = "0";

  void _incrementCounter() {
    setState(() {
      _regM = "0";
    });
  }

  void _keyPressed(String key) {}

  void _trimOperand() {}

  void _operator(String op) {}

  void _clearReg() {}

  void _memAdd() {}

  void _memMinus() {}

  void _memClear() {}

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
    _trimOperand();
  }

  void _keyPressedPlus() {
    _operator("+");
  }

  void _keyPressedMinus() {
    _operator("-");
  }

  void _keyPressedMult() {
    _operator("*");
  }

  void _keyPressedDivide() {
    _operator("/");
  }

  void _keyPressedAnd() {
    _operator("&");
  }

  void _keyPressedOr() {
    _operator("|");
  }

  void _keyPressedXor() {
    _operator("^");
  }

  void _keyPressedNot() {
    _operator("!");
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
    _operator("=");
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
            DefaultTextStyle(
              style: defaultTS,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    const Text("M"),
                    Expanded(
                      child: Text(
                        '$_regM',
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            //
            DefaultTextStyle(
              style: defaultTS,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    const Text("Op1"),
                    Expanded(
                      child: Text(
                        '$_op1',
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            //
            DefaultTextStyle(
              style: defaultTS,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    const Text("Op2"),
                    Expanded(
                      child: Text(
                        '$_op2',
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            //
            DefaultTextStyle(
              style: defaultTS,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    const Text("Result"),
                    Expanded(
                      child: Text(
                        '$_res',
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
              ),
            ),
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
