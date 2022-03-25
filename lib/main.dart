import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tool_changing_machine/utils/debouncer.dart';
import 'package:tool_changing_machine/utils/parser.dart';
import 'package:tool_changing_machine/utils/test_data.dart';
import 'package:tool_changing_machine/widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter tool changer machine',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ToolChangingMachinePage(toolsList: testTools),
    );
  }
}

class ToolChangingMachinePage extends StatefulWidget {
  final List<String> toolsList;
  const ToolChangingMachinePage({Key? key, required this.toolsList})
      : super(key: key);

  @override
  State<ToolChangingMachinePage> createState() =>
      _ToolChangingMachinePageState();
}

class _ToolChangingMachinePageState extends State<ToolChangingMachinePage> {
  late final TextEditingController targetToolController;
  late final TextEditingController currentToolController;
  late double itemSpacing;
  late int currentToolIndex;
  late int targetToolIndex;
  late int itemAmount;
  final Debouncer debouncer = Debouncer(milliseconds: 500);

  @override
  void initState() {
    itemAmount = widget.toolsList.length;
    currentToolIndex = Random().nextInt(itemAmount);
    targetToolIndex = Random().nextInt(itemAmount);
    targetToolController =
        TextEditingController(text: testTools.elementAt(targetToolIndex));
    currentToolController =
        TextEditingController(text: currentToolIndex.toString());
    updateBase();
    super.initState();
  }

  void updateBase() {
    itemSpacing = 360.0 / itemAmount;
    // toolsList = List.generate(itemAmount, (index) => 'tool$index');
  }

  double calculateItemAngle(int index) {
    return index * itemSpacing * (pi / 180);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final circleSize = size.height / 2;
    final circleLength = 2 * pi * (circleSize / 2);
    final itemSize = ((circleLength + circleLength / 3) / (itemAmount)) / pi;

    return Scaffold(
        body: Column(
      children: [
        TopBar(
          onNewToolSelected: (newToolName) => setState(() {
            currentToolIndex =
                textControllerIndexParser(newToolName, widget.toolsList);
          }),
          currentToolController: currentToolController,
          targetToolController: targetToolController,
          itemAmount: itemAmount,
          toolsList: widget.toolsList,
          onCurrentToolChange: (value) {
            currentToolIndex =
                textControllerIndexParser(value, widget.toolsList);
            setState(() {});
          },
          onTargetToolChange: (value) {
            targetToolIndex =
                textControllerIndexParser(value, widget.toolsList);
            setState(() {});
          },
          // onTotalAmountChange: (value) => debouncer.run(() {
          //       setState(() {
          //         final _parsedAmount = (int.tryParse(value) ?? 3);
          //         itemAmount = _parsedAmount <= 3 ? 3 : _parsedAmount;
          //         updateBase();
          //       });
          //     })
        ),
        Expanded(
          child: Center(
            child: Container(
              height: circleSize,
              width: circleSize,
              decoration: BoxDecoration(
                  color: Colors.grey[500], shape: BoxShape.circle),
              child: AnimatedRotation(
                duration: const Duration(milliseconds: 500),
                turns: currentToolIndex.toDouble() <= 0 ? 1 : 1,
                child: Stack(
                    alignment: Alignment.center,
                    children: List.generate(
                        itemAmount,
                        (index) => Transform.translate(
                              offset: Offset(0, -(circleSize - itemSize) / 2),
                              child: Transform.rotate(
                                angle: calculateItemAngle(index),
                                origin: Offset(0, (circleSize - itemSize) / 2),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 250),
                                  height: itemSize,
                                  width: itemSize,
                                  decoration: BoxDecoration(
                                      color: index == targetToolIndex
                                          ? Colors.red
                                          : index == currentToolIndex
                                              ? Colors.blue
                                              : Colors.grey[300],
                                      shape: BoxShape.circle),
                                ),
                              ),
                            ))),
              ),
            ),
          ),
        ),
      ],
    ));
  }
}
