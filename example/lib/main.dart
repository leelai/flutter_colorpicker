import 'package:flutter/cupertino.dart' show CupertinoTextField;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_colorpicker/flutter_colorpicker.dart';

void main() => runApp(const MaterialApp(home: MyApp()));

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool lightTheme = true;
  int indicatorListLength = 2;
  Color currentColor = const Color(0xFFFF0000);
  List<Color> currentColors = [
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.blue,
    Colors.indigo,
    Colors.purple,
  ];

  void changeColor(Color color) {
    setState(() => currentColor = color);
  }

  void changeColors(List<Color> colors) {
    setState(() => currentColors = colors);
  }

  // Just an example of how to use/interpret/format text input's result.
  Future<void> copyToClipboard(String input) async {
    late String textToCopy;
    final hex = input.toUpperCase();
    if (hex.startsWith('FF') && hex.length == 8) {
      textToCopy = hex.replaceFirst('FF', '');
    } else {
      textToCopy = hex;
    }
    await Clipboard.setData(ClipboardData(text: '#$textToCopy'));
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: lightTheme ? ThemeData.light() : ThemeData.dark(),
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: GestureDetector(
              child: const Text('Flutter Color Picker Example'),
              onDoubleTap: () => setState(() => lightTheme = !lightTheme),
            ),
            bottom: const TabBar(
              tabs: <Widget>[
                Tab(text: 'HSV'),
                Tab(text: 'Material'),
                Tab(text: 'Block'),
              ],
            ),
          ),
          body: TabBarView(
            physics: const NeverScrollableScrollPhysics(),
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    children: [
                      InkWell(
                        child: const Padding(
                          padding: EdgeInsets.all(18.0),
                          child: Text("+"),
                        ),
                        onTap: () {
                          setState(() {
                            if (indicatorListLength == 7) {
                              return;
                            }
                            indicatorListLength = indicatorListLength + 1;
                          });
                        },
                      ),
                      InkWell(
                        child: const Padding(
                          padding: EdgeInsets.all(18.0),
                          child: Text("-"),
                        ),
                        onTap: () {
                          setState(() {
                            if (indicatorListLength == 1) {
                              return;
                            }
                            indicatorListLength = indicatorListLength - 1;
                          });
                        },
                      ),
                    ],
                  ),
                  ColorPicker(
                    pickerColor: currentColor,
                    pickerColors: currentColors,
                    onColorChanged: changeColor,
                    onColorChanged2: changeColors,
                    enableAlpha: false,
                    displayThumbColor: false,
                    showLabel: false,
                    showIndicator: indicatorListLength == 1,
                    showIndicatorList: indicatorListLength > 1,
                    showColorPickerArea: false,
                    indicatorListLength: indicatorListLength,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            titlePadding: const EdgeInsets.all(10.0),
                            contentPadding: const EdgeInsets.all(10.0),
                            content: SingleChildScrollView(
                              child: ColorPicker(
                                pickerColor: currentColor,
                                onColorChanged: changeColor,
                                enableAlpha: false,
                                displayThumbColor: false,
                                showLabel: false,
                                showIndicator: true,
                                showIndicatorList: false,
                                showColorPickerArea: false,
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: Text(
                      'Change me (one indecator)',
                      style: TextStyle(
                        color: useWhiteForeground(currentColor)
                            ? const Color(0xffffffff)
                            : const Color(0xff000000),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: currentColor,
                      elevation: 3,
                    ),
                  ),
                  const SizedBox(height: 15),
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            titlePadding: const EdgeInsets.all(10.0),
                            contentPadding: const EdgeInsets.all(10.0),
                            content: SingleChildScrollView(
                              child: Column(
                                children: [
                                  InkWell(
                                    child: const Text("+"),
                                    onTap: () {
                                      setState(() {
                                        indicatorListLength =
                                            indicatorListLength + 1;
                                      });
                                    },
                                  ),
                                  InkWell(
                                    child: const Text("-"),
                                    onTap: () {
                                      setState(() {
                                        indicatorListLength =
                                            indicatorListLength - 1;
                                      });
                                    },
                                  ),
                                  Container(
                                    height: 20,
                                  ),
                                  ColorPicker(
                                    pickerColor: currentColor,
                                    pickerColors: currentColors,
                                    onColorChanged: changeColor,
                                    onColorChanged2: changeColors,
                                    enableAlpha: false,
                                    displayThumbColor: true,
                                    showLabel: false,
                                    showIndicator: indicatorListLength == 1,
                                    showIndicatorList: indicatorListLength > 1,
                                    showColorPickerArea: false,
                                    indicatorListLength: indicatorListLength,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: Text(
                      'Change me 2',
                      style: TextStyle(
                        color: useWhiteForeground(currentColor)
                            ? const Color(0xffffffff)
                            : const Color(0xff000000),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: currentColor,
                      elevation: 3,
                    ),
                  ),
                  const SizedBox(height: 15),
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            titlePadding: const EdgeInsets.all(0.0),
                            contentPadding: const EdgeInsets.all(0.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            content: SingleChildScrollView(
                              child: SlidePicker(
                                pickerColor: currentColor,
                                onColorChanged: changeColor,
                                paletteType: PaletteType.rgb,
                                enableAlpha: false,
                                displayThumbColor: true,
                                showLabel: false,
                                showIndicator: true,
                                indicatorBorderRadius:
                                    const BorderRadius.vertical(
                                  top: Radius.circular(25.0),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: Text(
                      'Change me again',
                      style: TextStyle(
                        color: useWhiteForeground(currentColor)
                            ? const Color(0xffffffff)
                            : const Color(0xff000000),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: currentColor,
                      elevation: 3,
                    ),
                  ),
                  const SizedBox(height: 15),
                  ElevatedButton(
                    onPressed: () {
                      // The initial value can be provided directly to the controller.
                      final textController =
                          TextEditingController(text: '#2F19DB');
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            scrollable: true,
                            titlePadding: const EdgeInsets.all(0.0),
                            contentPadding: const EdgeInsets.all(0.0),
                            content: Column(
                              children: [
                                ColorPicker(
                                  pickerColor: currentColor,
                                  onColorChanged: changeColor,
                                  colorPickerWidth: 300.0,
                                  pickerAreaHeightPercent: 0.7,
                                  enableAlpha:
                                      true, // hexInputController will respect it too.
                                  displayThumbColor: true,
                                  showLabel: true,
                                  paletteType: PaletteType.hsv,
                                  pickerAreaBorderRadius:
                                      const BorderRadius.only(
                                    topLeft: Radius.circular(2.0),
                                    topRight: Radius.circular(2.0),
                                  ),
                                  hexInputController: textController, // <- here
                                  portraitOnly: true,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  /* It can be any text field, for example:

                                  * TextField
                                  * TextFormField
                                  * CupertinoTextField
                                  * EditableText
                                  * any text field from 3-rd party package
                                  * your own text field

                                  so basically anything that supports/uses
                                  a TextEditingController for an editable text.
                                  */
                                  child: CupertinoTextField(
                                    controller: textController,
                                    // Everything below is purely optional.
                                    prefix: const Padding(
                                      padding: EdgeInsets.only(left: 8),
                                      child: Icon(Icons.tag),
                                    ),
                                    suffix: IconButton(
                                      icon: const Icon(
                                        Icons.content_paste_rounded,
                                      ),
                                      onPressed: () async =>
                                          copyToClipboard(textController.text),
                                    ),
                                    autofocus: true,
                                    maxLength: 9,
                                    inputFormatters: [
                                      // Any custom input formatter can be passed
                                      // here or use any Form validator you want.
                                      UpperCaseTextFormatter(),
                                      FilteringTextInputFormatter.allow(
                                        RegExp(kValidHexPattern),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                      );
                    },
                    child: Text(
                      'Change me via text input',
                      style: TextStyle(
                        color: useWhiteForeground(currentColor)
                            ? const Color(0xffffffff)
                            : const Color(0xff000000),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: currentColor,
                      elevation: 3,
                    ),
                  ),
                ],
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          titlePadding: const EdgeInsets.all(0.0),
                          contentPadding: const EdgeInsets.all(0.0),
                          content: SingleChildScrollView(
                            child: MaterialPicker(
                              pickerColor: currentColor,
                              onColorChanged: changeColor,
                              enableLabel: true,
                            ),
                          ),
                        );
                      },
                    );
                  },
                  child: Text(
                    'Change me',
                    style: TextStyle(
                      color: useWhiteForeground(currentColor)
                          ? const Color(0xffffffff)
                          : const Color(0xff000000),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: currentColor,
                    elevation: 3,
                  ),
                ),
              ),
              Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Select a color'),
                                content: SingleChildScrollView(
                                  child: BlockPicker(
                                    pickerColor: currentColor,
                                    onColorChanged: changeColor,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        child: Text(
                          'Change me',
                          style: TextStyle(
                            color: useWhiteForeground(currentColor)
                                ? const Color(0xffffffff)
                                : const Color(0xff000000),
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: currentColor,
                          elevation: 3,
                        ),
                      ),
                      const SizedBox(height: 15),
                      ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Select colors'),
                                content: SingleChildScrollView(
                                  child: MultipleChoiceBlockPicker(
                                    pickerColors: currentColors,
                                    onColorsChanged: changeColors,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        child: Text(
                          'Change me again',
                          style: TextStyle(
                            color: useWhiteForeground(currentColor)
                                ? const Color(0xffffffff)
                                : const Color(0xff000000),
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: currentColor,
                          elevation: 3,
                        ),
                      )
                    ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(oldValue, TextEditingValue newValue) =>
      TextEditingValue(
          text: newValue.text.toUpperCase(), selection: newValue.selection);
}
