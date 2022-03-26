import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tool_changing_machine/models/tool_rotation_response.dart';
import 'package:tool_changing_machine/utils/parser.dart';
import 'package:tool_changing_machine/utils/test_data.dart';
import 'package:tool_changing_machine/widgets/revolver_head.dart';
import 'package:tool_changing_machine/widgets/widgets.dart';

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
  late int currentToolIndex;
  late int targetToolIndex;
  late int itemAmount;
  ToolRotationResponse? toolRotationResponse;

  @override
  void initState() {
    itemAmount = widget.toolsList.length;
    currentToolIndex = Random().nextInt(itemAmount);
    targetToolIndex = Random().nextInt(itemAmount);
    targetToolController =
        TextEditingController(text: testTools.elementAt(targetToolIndex));
    currentToolController =
        TextEditingController(text: currentToolIndex.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        TopBar(
          onNewToolSelected: (newToolRotationResponse) => setState(() {
            currentToolIndex = getToolIndex(
                newToolRotationResponse.targetTool, widget.toolsList);
            toolRotationResponse = newToolRotationResponse;
          }),
          currentToolController: currentToolController,
          targetToolController: targetToolController,
          itemAmount: itemAmount,
          toolsList: widget.toolsList,
          onCurrentToolChange: (value) {
            currentToolIndex = getToolIndex(value, widget.toolsList);
            setState(() {});
          },
          onTargetToolChange: (value) {
            targetToolIndex = getToolIndex(value, widget.toolsList);
            setState(() {});
          },
        ),
        Expanded(
          child: Center(
            child: RevolverHead(
                toolsList: widget.toolsList,
                toolRotationResponse: toolRotationResponse,
                currentToolIndex: currentToolIndex,
                targetToolIndex: targetToolIndex),
          ),
        ),
      ],
    ));
  }
}
