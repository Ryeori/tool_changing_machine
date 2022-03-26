int getToolIndex(String valueToParse, List<String> toolsList) {
  final int? parsedResult = int.tryParse(valueToParse);
  if (parsedResult == null) {
    return toolsList.indexOf(valueToParse);
  } else {
    return parsedResult;
  }
}

String getToolName(String indexOrName, List<String> toolsList) {
  final int? parsedResult = int.tryParse(indexOrName);
  if (parsedResult == null) {
    return toolsList.singleWhere(
      (element) => element == indexOrName,
      orElse: () => '',
    );
  } else {
    return toolsList.elementAt(parsedResult);
  }
}
