import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tool_changing_machine/models/tool_rotation_response.dart';
import 'package:tool_changing_machine/tool_changing_machine.dart';
import 'package:tool_changing_machine/utils/parser.dart';

class ToolChangingMachineTextField extends StatefulWidget {
  final TextEditingController controller;
  final int itemAmount;
  final List<String> toolsList;
  final Function() refreshParent;
  final String label;
  const ToolChangingMachineTextField(
      {Key? key,
      required this.controller,
      required this.itemAmount,
      required this.toolsList,
      required this.refreshParent,
      required this.label})
      : super(key: key);

  @override
  State<ToolChangingMachineTextField> createState() =>
      _ToolChangingMachineTextFieldState();
}

class _ToolChangingMachineTextFieldState
    extends State<ToolChangingMachineTextField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
        decoration: InputDecoration(label: Text(widget.label)),
        controller: widget.controller,
        onChanged: (value) {
          if (getToolIndex(value, widget.toolsList) > widget.itemAmount - 1) {
            widget.controller.text = (widget.itemAmount - 1).toString();
            widget.controller.selection = TextSelection.fromPosition(
                TextPosition(offset: widget.controller.text.length));
          }
          widget.refreshParent();
        });
  }
}

class TopBar extends StatefulWidget {
  final int itemAmount;
  final List<String> toolsList;
  final TextEditingController targetToolController;
  final TextEditingController currentToolController;
  // final Function(String value) onTotalAmountChange;
  final Function(String value) onTargetToolChange;
  final Function(String value) onCurrentToolChange;
  final Function(ToolRotationResponse toolRotationResponse) onNewToolSelected;
  const TopBar(
      {Key? key,
      required this.toolsList,
      required this.currentToolController,
      required this.targetToolController,
      required this.itemAmount,
      // required this.onTotalAmountChange,
      required this.onTargetToolChange,
      required this.onCurrentToolChange,
      required this.onNewToolSelected})
      : super(key: key);

  @override
  State<TopBar> createState() => _TopBarState();
}

class _TopBarState extends State<TopBar> {
  late ToolChangingMachine toolChangingMachine;
  ToolRotationResponse? toolRotationResponse;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
                child: ToolChangingMachineTextField(
              controller: widget.targetToolController,
              itemAmount: widget.itemAmount,
              toolsList: widget.toolsList,
              label: 'Target tool index or name',
              refreshParent: () => setState(() {
                widget.onTargetToolChange(widget.targetToolController.text);
              }),
            )),
            const VerticalDivider(),
            Expanded(
                child: ToolChangingMachineTextField(
              controller: widget.currentToolController,
              itemAmount: widget.itemAmount,
              toolsList: widget.toolsList,
              label: 'Current tool index or name',
              refreshParent: () => setState(() {
                widget.onCurrentToolChange(widget.currentToolController.text);
              }),
            )),
            const VerticalDivider(),
            TextButton(
                onPressed: () {
                  setState(() {
                    toolChangingMachine = ToolChangingMachine(
                        currentToolIndex:
                            (int.tryParse(widget.currentToolController.text) ??
                                0),
                        targetTool: getToolName(
                            widget.targetToolController.text.trim(),
                            widget.toolsList),
                        toolsList: widget.toolsList);
                    toolRotationResponse =
                        toolChangingMachine.proceedToolChanging();
                    if (toolRotationResponse != null) {
                      widget.currentToolController.text = widget.toolsList
                          .indexOf(toolRotationResponse!.targetTool)
                          .toString();
                      toolRotationResponse = toolRotationResponse;
                      widget.onNewToolSelected(toolRotationResponse!);
                    }
                  });
                },
                child: const Text('Select new tool')),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 25.0),
          child: Text(toolRotationResponse != null
              ? 'Turns ${describeEnum(toolRotationResponse!.rotationDirection)} ${toolRotationResponse!.rotationTimes} ${toolRotationResponse!.rotationTimes == 1 ? 'time' : 'times'} and select - ${toolRotationResponse!.targetTool}'
              : ''),
        ),
      ],
    );
  }
}
