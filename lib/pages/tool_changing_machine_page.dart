import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tool_changing_machine/models/tool_rotation_response.dart';
import 'package:tool_changing_machine/utils/parser.dart';
import 'package:tool_changing_machine/utils/test_data.dart';
import 'package:tool_changing_machine/widgets/revolver_head.dart';
import 'package:tool_changing_machine/widgets/widgets.dart';

class ToolChangingMachinePage extends StatefulWidget {
  final List<String> toolsList;
  const ToolChangingMachinePage({Key? key, required this.toolsList})
      : super(key: key);

  @override
  State<ToolChangingMachinePage> createState() =>
      _ToolChangingMachinePageState();
}

class _ToolChangingMachinePageState extends State<ToolChangingMachinePage> {
  final Random random = Random();
  late final TextEditingController targetToolController;
  late final TextEditingController currentToolController;
  late int currentToolIndex;
  late int targetToolIndex;
  ToolRotationResponse? toolRotationResponse;

  @override
  void initState() {
    currentToolIndex = random.nextInt(widget.toolsList.length);
    targetToolIndex = random.nextInt(widget.toolsList.length);
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
          itemAmount: widget.toolsList.length,
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
