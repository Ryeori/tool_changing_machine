enum RotationDirection { left, right, none }

class ToolRotationResponse {
  final int rotationTimes;
  final RotationDirection rotationDirection;
  final String targetTool;
  ToolRotationResponse({
    required this.rotationTimes,
    required this.rotationDirection,
    required this.targetTool,
  });

  ToolRotationResponse copyWith({
    int? rotationTimes,
    RotationDirection? rotationDirection,
    String? targetTool,
  }) {
    return ToolRotationResponse(
      rotationTimes: rotationTimes ?? this.rotationTimes,
      rotationDirection: rotationDirection ?? this.rotationDirection,
      targetTool: targetTool ?? this.targetTool,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ToolRotationResponse &&
        other.rotationTimes == rotationTimes &&
        other.rotationDirection == rotationDirection &&
        other.targetTool == targetTool;
  }

  @override
  int get hashCode =>
      rotationTimes.hashCode ^ rotationDirection.hashCode ^ targetTool.hashCode;
}
