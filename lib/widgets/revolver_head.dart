import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tool_changing_machine/models/tool_rotation_response.dart';

class RevolverHead extends StatefulWidget {
  final List<String> toolsList;
  final int currentToolIndex;
  final int targetToolIndex;
  final ToolRotationResponse? toolRotationResponse;
  const RevolverHead(
      {Key? key,
      required this.toolsList,
      required this.currentToolIndex,
      required this.targetToolIndex,
      this.toolRotationResponse})
      : super(key: key);

  @override
  State<RevolverHead> createState() => _RevolverHeadState();
}

class _RevolverHeadState extends State<RevolverHead>
    with SingleTickerProviderStateMixin {
  late final Duration animationDuration;
  final Curve animationCurve = Curves.easeInOutCubic;
  final int animationSpeed = 300;
  late double itemSpacing;
  late int itemAmount;
  late AnimationController _rotationAnimationController;
  bool avalibleToAnimate = true;

  ToolRotationResponse localToolRotationResponse = ToolRotationResponse(
      rotationTimes: 0,
      rotationDirection: RotationDirection.none,
      targetTool: '');

  void updateBase() {
    itemSpacing = 360.0 / itemAmount;
  }

  double calculateItemAngle(int index) {
    return index * itemSpacing * (pi / 180);
  }

  @override
  void initState() {
    //TODO: REFACTOR
    itemAmount = widget.toolsList.length;
    _rotationAnimationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    //TODO: REFACTOR
    //Animation speed control(animationSpeed and '45')
    animationDuration = Duration(
        milliseconds: sqrt((widget.toolRotationResponse?.rotationTimes ?? 1) *
                    animationSpeed)
                .ceil() *
            45);
    _rotationAnimationController.animateTo(
        ((1 / itemAmount) * (itemAmount - widget.currentToolIndex)) / 2,
        curve: animationCurve,
        duration: animationDuration);
    updateBase();
    super.initState();
  }

  @override
  void dispose() {
    _rotationAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //TODO: REFACTOR
    final size = MediaQuery.of(context).size;
    final circleSize = size.height / 2;
    final circleLength = 2 * pi * (circleSize / 2);
    final itemSize = ((circleLength + circleLength / 3) / (itemAmount)) / pi;

    //TODO: REFACTOR
    if (localToolRotationResponse != widget.toolRotationResponse &&
        widget.toolRotationResponse != null) {
      localToolRotationResponse = widget.toolRotationResponse!;
      localToolRotationResponse.rotationDirection == RotationDirection.left
          ? _rotationAnimationController.animateTo(
              _rotationAnimationController.value +
                  ((1 / itemAmount) * localToolRotationResponse.rotationTimes) /
                      2,
              curve: animationCurve,
              duration: animationDuration)
          : _rotationAnimationController.animateBack(
              _rotationAnimationController.value -
                  ((1 / itemAmount) * localToolRotationResponse.rotationTimes) /
                      2,
              curve: animationCurve,
              duration: animationDuration);
    }
    return InkWell(
      child: RotationTransition(
        turns:
            Tween(begin: -1.0, end: 1.0).animate(_rotationAnimationController),
        child: Container(
          height: circleSize,
          width: circleSize,
          decoration:
              BoxDecoration(color: Colors.grey[500], shape: BoxShape.circle),
          child: AnimatedRotation(
            duration: const Duration(milliseconds: 500),
            turns: widget.currentToolIndex.toDouble() <= 0 ? 1 : 1,
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
                                  border: index == widget.targetToolIndex
                                      ? Border.all(
                                          width: 3, color: Colors.red.shade400)
                                      : const Border(),
                                  color: index == widget.currentToolIndex
                                      ? Colors.blue
                                      : Colors.grey[300],
                                  shape: BoxShape.circle),
                              child: Center(child: Text(index.toString())),
                            ),
                          ),
                        ))),
          ),
        ),
      ),
    );
  }
}
