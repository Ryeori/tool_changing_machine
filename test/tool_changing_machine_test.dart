import 'package:flutter_test/flutter_test.dart';
import 'package:tool_changing_machine/tool_changing_machine.dart';
import 'package:tool_changing_machine/models/tool_rotation_response.dart';

void main() {
  test('Moved right 23 times and select tool25', () {
    String targetTool = 'tool25';

    final ToolChangingMachine toolChangingMachine = ToolChangingMachine(
        toolsList: List.generate(100, (index) => 'tool$index'),
        currentToolIndex: 2,
        targetTool: targetTool);

    final ToolRotationResponse? toolRotationResponse =
        toolChangingMachine.proceedToolChanging();

    expect(
        toolRotationResponse,
        ToolRotationResponse(
            rotationTimes: 23,
            rotationDirection: RotationDirection.right,
            targetTool: targetTool));
  });

  test('Moved right 1 times and select tool24', () {
    String targetTool = 'tool24';

    final ToolChangingMachine toolChangingMachine = ToolChangingMachine(
        toolsList: List.generate(25, (index) => 'tool$index'),
        currentToolIndex: 23,
        targetTool: targetTool);

    final ToolRotationResponse? toolRotationResponse =
        toolChangingMachine.proceedToolChanging();

    expect(
        toolRotationResponse,
        ToolRotationResponse(
            rotationTimes: 1,
            rotationDirection: RotationDirection.right,
            targetTool: targetTool));
  });

  test('Moved left 4 times and select tool9', () {
    String targetTool = 'tool5';

    final ToolChangingMachine toolChangingMachine = ToolChangingMachine(
        toolsList: List.generate(10, (index) => 'tool$index'),
        currentToolIndex: 9,
        targetTool: targetTool);

    final ToolRotationResponse? toolRotationResponse =
        toolChangingMachine.proceedToolChanging();

    expect(
        toolRotationResponse,
        ToolRotationResponse(
            rotationTimes: 4,
            rotationDirection: RotationDirection.left,
            targetTool: targetTool));
  });

  test('Moved right 51 times and select tool110', () {
    String targetTool = 'tool110';

    final ToolChangingMachine toolChangingMachine = ToolChangingMachine(
        toolsList: List.generate(125, (index) => 'tool$index'),
        currentToolIndex: 59,
        targetTool: targetTool);

    final ToolRotationResponse? toolRotationResponse =
        toolChangingMachine.proceedToolChanging();

    expect(
        toolRotationResponse,
        ToolRotationResponse(
            rotationTimes: 51,
            rotationDirection: RotationDirection.right,
            targetTool: targetTool));
  });

  test('Moved right 1 times and select tool0', () {
    String targetTool = 'tool0';

    final ToolChangingMachine toolChangingMachine = ToolChangingMachine(
        toolsList: List.generate(10, (index) => 'tool$index'),
        currentToolIndex: 9,
        targetTool: targetTool);

    final ToolRotationResponse? toolRotationResponse =
        toolChangingMachine.proceedToolChanging();

    expect(
        toolRotationResponse,
        ToolRotationResponse(
            rotationTimes: 1,
            rotationDirection: RotationDirection.right,
            targetTool: targetTool));
  });

  test('Moved left 1 times and select tool0', () {
    String targetTool = 'tool9';

    final ToolChangingMachine toolChangingMachine = ToolChangingMachine(
        toolsList: List.generate(10, (index) => 'tool$index'),
        currentToolIndex: 0,
        targetTool: targetTool);

    final ToolRotationResponse? toolRotationResponse =
        toolChangingMachine.proceedToolChanging();

    expect(
        toolRotationResponse,
        ToolRotationResponse(
            rotationTimes: 1,
            rotationDirection: RotationDirection.left,
            targetTool: targetTool));
  });
}
