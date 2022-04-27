import 'package:tool_changing_machine/models/tool_rotation_response.dart';
import 'package:tool_changing_machine/utils/constant.dart';
import 'package:tool_changing_machine/utils/parser.dart';

class ToolChangingMachine {
  final List<String> toolsList;

  final int currentToolIndex;

  final String targetTool;

  ToolChangingMachine(
      {required this.toolsList,
      required this.currentToolIndex,
      required this.targetTool});

  ToolRotationResponse? proceedToolChanging() {
    final targetToolIndex = getToolIndex(targetTool, toolsList);
    if (targetToolIndex == -1) {
      return null;
    } else {
      final double rotationStep = circleLength / toolsList.length;
      final int indexDifference = targetToolIndex - currentToolIndex;
      final double startToTargetLength = indexDifference * rotationStep;
      final bool pointsLengthLessThanPi = startToTargetLength.abs() < piNumber;

      return _proceedMove(
          pointsLengthLessThanPi
              ? indexDifference.abs()
              : toolsList.length - indexDifference.abs(),
          toolsList.elementAt(targetToolIndex),
          (indexDifference.isNegative && pointsLengthLessThanPi)
              ? RotationDirection.left
              : RotationDirection.right);
    }
  }

  ToolRotationResponse _proceedMove(
      int rotationTimes, String tool, RotationDirection rotationDirection) {
    return ToolRotationResponse(
        rotationTimes: rotationTimes,
        rotationDirection: rotationDirection,
        targetTool: targetTool);
  }
}
