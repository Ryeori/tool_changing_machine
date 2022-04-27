import 'package:flutter/material.dart';
import 'package:tool_changing_machine/pages/tool_changing_machine_page.dart';
import 'package:tool_changing_machine/utils/test_data.dart';

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
