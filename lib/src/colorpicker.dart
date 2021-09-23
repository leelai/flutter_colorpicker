/// HSV(HSB)/HSL Color Picker example
///
/// You can create your own layout by importing `hsv_picker.dart`.

library hsv_picker;

import 'package:flutter/material.dart';

import 'package:flutter_colorpicker/src/hsv_picker.dart';
import 'package:flutter_colorpicker/src/utils.dart';

// The default layout of Color Picker.
class ColorPicker extends StatefulWidget {
  const ColorPicker({
    Key? key,
    required this.pickerColor,
    required this.onColorChanged,
    this.pickerHsvColor,
    this.onHsvColorChanged,
    this.paletteType = PaletteType.hsv,
    this.enableAlpha = true,
    this.showLabel = true,
    this.showIndicator = true,
    this.showColorPickerArea = true,
    this.labelTextStyle,
    this.displayThumbColor = false,
    this.portraitOnly = false,
    this.colorPickerWidth = 300.0,
    this.pickerAreaHeightPercent = 1.0,
    this.pickerAreaBorderRadius = const BorderRadius.all(Radius.zero),
    this.hexInputController,
    this.showIndicatorList = true,
    this.showIndicatorListNum = 1,
    this.maxIndex = 1,
  }) : super(key: key);

  final Color pickerColor;
  final ValueChanged<Color> onColorChanged;
  final HSVColor? pickerHsvColor;
  final ValueChanged<HSVColor>? onHsvColorChanged;
  final PaletteType paletteType;
  final bool enableAlpha;
  final bool showLabel;
  final bool showIndicator;
  final bool showIndicatorList;
  final int showIndicatorListNum;
  final bool showColorPickerArea;
  final TextStyle? labelTextStyle;
  final bool displayThumbColor;
  final bool portraitOnly;
  final double colorPickerWidth;
  final double pickerAreaHeightPercent;
  final BorderRadius pickerAreaBorderRadius;
  final int maxIndex;

  /// Allows setting the color using text input, via [TextEditingController].
  ///
  /// Listens to [String] input and trying to convert it to the valid [Color].
  /// Contains basic validator, that requires final input to be provided
  /// in one of those formats:
  ///
  /// * RGB
  /// * #RGB
  /// * RRGGBB
  /// * #RRGGBB
  /// * AARRGGBB
  /// * #AARRGGBB
  ///
  /// Where: A stands for Alpha, R for Red, G for Green, and B for blue color.
  /// It will only accept 3/6/8 long HEXs with an optional hash (`#`) at the beginning.
  /// Allowed characters are Latin A-F case insensitive and numbers 0-9.
  /// It does respect the [enableAlpha] flag, so if alpha is disabled, all inputs
  /// with transparency are also converted to non-transparent color values.
  /// ```dart
  ///   MaterialButton(
  ///    elevation: 3.0,
  ///    onPressed: () {
  ///      // The initial value can be provided directly to the controller.
  ///      final textController =
  ///          TextEditingController(text: '#2F19DB');
  ///      showDialog(
  ///        context: context,
  ///        builder: (BuildContext context) {
  ///          return AlertDialog(
  ///            scrollable: true,
  ///            titlePadding: const EdgeInsets.all(0.0),
  ///            contentPadding: const EdgeInsets.all(0.0),
  ///            content: Column(
  ///              children: [
  ///                ColorPicker(
  ///                  pickerColor: currentColor,
  ///                  onColorChanged: changeColor,
  ///                  colorPickerWidth: 300.0,
  ///                  pickerAreaHeightPercent: 0.7,
  ///                  enableAlpha:
  ///                      true, // hexInputController will respect it too.
  ///                  displayThumbColor: true,
  ///                  showLabel: true,
  ///                  paletteType: PaletteType.hsv,
  ///                  pickerAreaBorderRadius: const BorderRadius.only(
  ///                    topLeft: const Radius.circular(2.0),
  ///                    topRight: const Radius.circular(2.0),
  ///                  ),
  ///                  hexInputController: textController, // <- here
  ///                  portraitOnly: true,
  ///                ),
  ///                Padding(
  ///                  padding: const EdgeInsets.all(16),
  ///                  /* It can be any text field, for example:
  ///                  * TextField
  ///                  * TextFormField
  ///                  * CupertinoTextField
  ///                  * EditableText
  ///                  * any text field from 3-rd party package
  ///                  * your own text field
  ///                  so basically anything that supports/uses
  ///                  a TextEditingController for an editable text.
  ///                  */
  ///                  child: CupertinoTextField(
  ///                    controller: textController,
  ///                    // Everything below is purely optional.
  ///                    prefix: Padding(
  ///                      padding: const EdgeInsets.only(left: 8),
  ///                      child: const Icon(Icons.tag),
  ///                    ),
  ///                    suffix: IconButton(
  ///                      icon:
  ///                          const Icon(Icons.content_paste_rounded),
  ///                      onPressed: () async =>
  ///                          copyToClipboard(textController.text),
  ///                    ),
  ///                    autofocus: true,
  ///                    maxLength: 9,
  ///                    inputFormatters: [
  ///                      // Any custom input formatter can be passed
  ///                      // here or use any Form validator you want.
  ///                      UpperCaseTextFormatter(),
  ///                      FilteringTextInputFormatter.allow(
  ///                          RegExp(kValidHexPattern)),
  ///                    ],
  ///                  ),
  ///                )
  ///              ],
  ///            ),
  ///          );
  ///        },
  ///      );
  ///    },
  ///    child: const Text('Change me via text input'),
  ///    color: currentColor,
  ///    textColor: useWhiteForeground(currentColor)
  ///        ? const Color(0xffffffff)
  ///        : const Color(0xff000000),
  ///  ),
  /// ```
  ///
  /// Do not forget to `dispose()` your [TextEditingController] if you creating
  /// it inside any kind of [StatefulWidget]'s [State].
  /// Reference: https://en.wikipedia.org/wiki/Web_colors#Hex_triplet
  final TextEditingController? hexInputController;

  @override
  _ColorPickerState createState() => _ColorPickerState();
}

class _ColorPickerState extends State<ColorPicker> {
  int selected = 0;
  List<HSVColor> hsvColors = [
    HSVColor.fromColor(const Color(0xFFFF0000)),
    HSVColor.fromColor(const Color(0xFFFF0000)),
    HSVColor.fromColor(const Color(0xFFFF0000)),
    HSVColor.fromColor(const Color(0xFFFF0000)),
    HSVColor.fromColor(const Color(0xFFFF0000)),
    HSVColor.fromColor(const Color(0xFFFF0000)),
    HSVColor.fromColor(const Color(0xFFFF0000)),
  ];

  @override
  void initState() {
    super.initState();
    hsvColors[selected] = (widget.pickerHsvColor != null)
        ? widget.pickerHsvColor as HSVColor
        : HSVColor.fromColor(widget.pickerColor);
    // If there's no initial text in `hexInputController`,
    if (widget.hexInputController?.text.isEmpty == true) {
      // set it to the current's color HEX value.
      widget.hexInputController?.text = colorToHex(
        hsvColors[selected].toColor(),
        enableAlpha: widget.enableAlpha,
      );
    }
    // Listen to the text input, If there is an `hexInputController` provided.
    widget.hexInputController?.addListener(colorPickerTextInputListener);
  }

  @override
  void didUpdateWidget(ColorPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    hsvColors[selected] = (widget.pickerHsvColor != null)
        ? widget.pickerHsvColor as HSVColor
        : HSVColor.fromColor(widget.pickerColor);
  }

  void colorPickerTextInputListener() {
    // It can't be null really, since it's only listening if the controller
    // is provided, but it may help to calm the Dart analyzer in the future.
    if (widget.hexInputController == null) return;
    // If a user is inserting/typing any text — try to get the color value from it,
    final Color? color = colorFromHex(widget.hexInputController!.text,
        // and interpret its transparency, dependent on the widget's settings.
        enableAlpha: widget.enableAlpha);
    // If it's the valid color:
    if (color != null) {
      // set it as the current color and
      setState(() => hsvColors[selected] = HSVColor.fromColor(color));
      // notify with a callback.
      widget.onColorChanged(color);
      if (widget.onHsvColorChanged != null) {
        widget.onHsvColorChanged!(hsvColors[selected]);
      }
    }
  }

  Widget colorPickerSlider(TrackType trackType) {
    return ColorPickerSlider(
      trackType,
      hsvColors[selected],
      (HSVColor color) {
        // Update text in `hexInputController` if provided.
        widget.hexInputController?.text =
            colorToHex(color.toColor(), enableAlpha: widget.enableAlpha);
        setState(() => hsvColors[selected] = color);
        widget.onColorChanged(hsvColors[selected].toColor());
        if (widget.onHsvColorChanged != null) {
          widget.onHsvColorChanged!(hsvColors[selected]);
        }
      },
      displayThumbColor: widget.displayThumbColor,
    );
  }

  Widget colorPickerArea() {
    return ClipRRect(
      borderRadius: widget.pickerAreaBorderRadius,
      child: ColorPickerArea(
        hsvColors[selected],
        (HSVColor color) {
          // Update text in `hexInputController` if provided.
          widget.hexInputController?.text =
              colorToHex(color.toColor(), enableAlpha: widget.enableAlpha);
          setState(() => hsvColors[selected] = color);
          widget.onColorChanged(hsvColors[selected].toColor());
          if (widget.onHsvColorChanged != null) {
            widget.onHsvColorChanged!(hsvColors[selected]);
          }
        },
        widget.paletteType,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).orientation == Orientation.portrait ||
        widget.portraitOnly) {
      return Column(
        children: <Widget>[
          if (widget.showColorPickerArea)
            SizedBox(
              width: widget.colorPickerWidth,
              height: widget.colorPickerWidth * widget.pickerAreaHeightPercent,
              child: colorPickerArea(),
            ),
          if (widget.showIndicator) ColorIndicator(hsvColors[selected]),
          if (widget.showIndicatorList) indicatorList(widget.maxIndex),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // if (widget.showIndicator) ColorIndicator(currentHsvColor),
              Expanded(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 40.0,
                      width: widget.colorPickerWidth,
                      child: colorPickerSlider(TrackType.hue),
                    ),
                    if (widget.enableAlpha)
                      SizedBox(
                        height: 40.0,
                        width: widget.colorPickerWidth - 75.0,
                        child: colorPickerSlider(TrackType.alpha),
                      ),
                  ],
                ),
              ),
            ],
          ),
          if (widget.showLabel)
            ColorPickerLabel(
              hsvColors[selected],
              enableAlpha: widget.enableAlpha,
              textStyle: widget.labelTextStyle,
            ),
          //const SizedBox(height: 20.0),
        ],
      );
    } else {
      return Row(
        children: <Widget>[
          if (widget.showColorPickerArea)
            Expanded(
              child: SizedBox(
                width: 300.0,
                height: 200.0,
                child: colorPickerArea(),
              ),
            ),
          Column(
            children: <Widget>[
              if (widget.showIndicatorList) indicatorList(widget.maxIndex),
              Row(
                children: <Widget>[
                  const SizedBox(width: 20.0),
                  if (widget.showIndicator) ColorIndicator(hsvColors[selected]),
                  Column(
                    children: <Widget>[
                      SizedBox(
                        height: 40.0,
                        width: 260.0,
                        child: colorPickerSlider(TrackType.hue),
                      ),
                      if (widget.enableAlpha)
                        SizedBox(
                          height: 40.0,
                          width: 260.0,
                          child: colorPickerSlider(TrackType.alpha),
                        ),
                    ],
                  ),
                  const SizedBox(width: 10.0),
                ],
              ),
              if (widget.showLabel) const SizedBox(height: 20.0),
              if (widget.showLabel)
                ColorPickerLabel(
                  hsvColors[selected],
                  enableAlpha: widget.enableAlpha,
                  textStyle: widget.labelTextStyle,
                ),
            ],
          ),
        ],
      );
    }
  }

  Widget indicatorList(int maxIndex) {
    return Row(
      children: [
        ColorIndicator(
          hsvColors[0],
          isSelected: 0 == selected,
          activate: true,
          onClick: () {
            setState(() {
              selected = 0;
            });
          },
        ),
        ColorIndicator(
          hsvColors[1],
          isSelected: 1 == selected,
          activate: 1 <= maxIndex,
          onClick: () {
            setState(() {
              selected = 1;
            });
          },
        ),
        ColorIndicator(
          hsvColors[2],
          isSelected: 2 == selected,
          activate: 2 <= maxIndex,
          onClick: () {
            setState(() {
              selected = 2;
            });
          },
        ),
        ColorIndicator(
          hsvColors[3],
          isSelected: 3 == selected,
          activate: 3 <= maxIndex,
          onClick: () {
            setState(() {
              selected = 3;
            });
          },
        ),
        ColorIndicator(
          hsvColors[4],
          isSelected: 4 == selected,
          activate: 4 <= maxIndex,
          onClick: () {
            setState(() {
              selected = 4;
            });
          },
        ),
        ColorIndicator(
          hsvColors[5],
          isSelected: 5 == selected,
          activate: 5 <= maxIndex,
          onClick: () {
            setState(() {
              selected = 5;
            });
          },
        ),
        ColorIndicator(
          hsvColors[6],
          isSelected: 6 == selected,
          activate: 6 <= maxIndex,
          onClick: () {
            setState(() {
              selected = 6;
            });
          },
        ),
      ],
    );
  }
}

// The Color Picker with three sliders only. Support HSV, HSL and RGB color model.
class SlidePicker extends StatefulWidget {
  const SlidePicker({
    Key? key,
    required this.pickerColor,
    required this.onColorChanged,
    this.paletteType = PaletteType.hsv,
    this.enableAlpha = true,
    this.sliderSize = const Size(260, 40),
    this.showSliderText = true,
    this.sliderTextStyle,
    this.showLabel = true,
    this.labelTextStyle,
    this.showIndicator = true,
    this.indicatorSize = const Size(280, 50),
    this.indicatorAlignmentBegin = const Alignment(-1.0, -3.0),
    this.indicatorAlignmentEnd = const Alignment(1.0, 3.0),
    this.displayThumbColor = false,
    this.indicatorBorderRadius = const BorderRadius.all(Radius.zero),
  }) : super(key: key);

  final Color pickerColor;
  final ValueChanged<Color> onColorChanged;
  final PaletteType paletteType;
  final bool enableAlpha;
  final Size sliderSize;
  final bool showSliderText;
  final TextStyle? sliderTextStyle;
  final bool showLabel;
  final TextStyle? labelTextStyle;
  final bool showIndicator;
  final Size indicatorSize;
  final AlignmentGeometry indicatorAlignmentBegin;
  final AlignmentGeometry indicatorAlignmentEnd;
  final bool displayThumbColor;
  final BorderRadius indicatorBorderRadius;

  @override
  State<StatefulWidget> createState() => _SlidePickerState();
}

class _SlidePickerState extends State<SlidePicker> {
  HSVColor currentHsvColor = const HSVColor.fromAHSV(0.0, 0.0, 0.0, 0.0);

  @override
  void initState() {
    super.initState();
    currentHsvColor = HSVColor.fromColor(widget.pickerColor);
  }

  @override
  void didUpdateWidget(SlidePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    currentHsvColor = HSVColor.fromColor(widget.pickerColor);
  }

  Widget colorPickerSlider(TrackType trackType) {
    return ColorPickerSlider(
      trackType,
      currentHsvColor,
      (HSVColor color) {
        setState(() => currentHsvColor = color);
        widget.onColorChanged(currentHsvColor.toColor());
      },
      displayThumbColor: widget.displayThumbColor,
      fullThumbColor: true,
    );
  }

  Widget indicator() {
    return ClipRRect(
      borderRadius: widget.indicatorBorderRadius,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Container(
        width: widget.indicatorSize.width,
        height: widget.indicatorSize.height,
        margin: const EdgeInsets.only(bottom: 15.0),
        foregroundDecoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              widget.pickerColor,
              widget.pickerColor,
              currentHsvColor.toColor(),
              currentHsvColor.toColor(),
            ],
            begin: widget.indicatorAlignmentBegin,
            end: widget.indicatorAlignmentEnd,
            stops: const [0.0, 0.5, 0.5, 1.0],
          ),
        ),
        child: const CustomPaint(painter: CheckerPainter()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<SizedBox> sliders = [
      for (TrackType palette in [
        if (widget.paletteType == PaletteType.hsv) ...[
          TrackType.hue,
          TrackType.saturation,
          TrackType.value,
        ],
        if (widget.paletteType == PaletteType.hsl) ...[
          TrackType.hue,
          TrackType.saturationForHSL,
          TrackType.lightness,
        ],
        if (widget.paletteType == PaletteType.rgb) ...[
          TrackType.red,
          TrackType.green,
          TrackType.blue,
        ],
      ])
        SizedBox(
          width: widget.sliderSize.width,
          height: widget.sliderSize.height,
          child: Row(
            children: <Widget>[
              if (widget.showSliderText)
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Text(
                    palette.toString().split('.').last[0].toUpperCase(),
                    style: widget.sliderTextStyle ??
                        Theme.of(context).textTheme.bodyText1?.copyWith(
                            fontWeight: FontWeight.bold, fontSize: 16.0),
                  ),
                ),
              Expanded(child: colorPickerSlider(palette)),
            ],
          ),
        ),
    ];
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        if (widget.showIndicator) indicator(),
        ...sliders,
        if (widget.enableAlpha)
          SizedBox(
            height: 40.0,
            width: 260.0,
            child: colorPickerSlider(TrackType.alpha),
          ),
        const SizedBox(height: 20.0),
        if (widget.showLabel)
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: ColorPickerLabel(
              currentHsvColor,
              enableAlpha: widget.enableAlpha,
              textStyle: widget.labelTextStyle,
            ),
          ),
      ],
    );
  }
}
