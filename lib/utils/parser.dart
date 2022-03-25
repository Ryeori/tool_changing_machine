int textControllerIndexParser(String valueToParse, List<String> toolsList) {
  final parseResult = int.tryParse(valueToParse);
  if (parseResult == null) {
    return toolsList.indexOf(valueToParse);
  } else {
    return parseResult;
  }
}
