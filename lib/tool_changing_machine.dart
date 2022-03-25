import 'package:flutter/foundation.dart';
import 'package:tool_changing_machine/models/tool_rotation_response.dart';
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
    final targetToolIndex = textControllerIndexParser(targetTool, toolsList);
    if (targetToolIndex == -1) {
      return null;
    }
    final int indexDifference = targetToolIndex - currentToolIndex;

    final int absoluteIndexDifference = indexDifference.abs();

    if (absoluteIndexDifference > (toolsList.length ~/ 2)) {
      //Amount of times need to rotate until target tool
      final int rotationOffset = toolsList.length - absoluteIndexDifference;

      return indexDifference.isNegative
          ? _proceedMove(
              rotationOffset,
              toolsList.elementAt(((currentToolIndex + rotationOffset) >=
                          toolsList.length
                      ? (toolsList.length - (currentToolIndex + rotationOffset))
                      : (currentToolIndex + rotationOffset))
                  .abs()),
              RotationDirection.right)
          : _proceedMove(
              rotationOffset,
              toolsList.elementAt(
                  ((currentToolIndex - rotationOffset).isNegative
                          ? toolsList.length -
                              (currentToolIndex - rotationOffset).abs()
                          : currentToolIndex - rotationOffset)
                      .abs()),
              RotationDirection.left);
    } else {
      return _proceedMove(
          absoluteIndexDifference,
          toolsList.elementAt(!indexDifference.isNegative
              ? currentToolIndex + absoluteIndexDifference
              : currentToolIndex - absoluteIndexDifference),
          !indexDifference.isNegative
              ? RotationDirection.right
              : RotationDirection.left);
    }
  }

  ToolRotationResponse _proceedMove(
      int rotationTimes, String tool, RotationDirection rotationDirection) {
    print(
        'Moved ${describeEnum(rotationDirection)} $rotationTimes times and selected $tool');
    return ToolRotationResponse(
        rotationTimes: rotationTimes,
        rotationDirection: rotationDirection,
        targetTool: targetTool);
  }
}
