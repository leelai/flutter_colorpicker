/// The components of HSV Color Picker
///
/// Try to create a Color Picker with other layout on your own :)

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:flutter_colorpicker/src/utils.dart';

enum PaletteType { hsv, hsl, rgb }
enum TrackType {
  hue,
  saturation,
  saturationForHSL,
  value,
  lightness,
  red,
  green,
  blue,
  alpha,
  custom,
}
enum ColorModel { hex, rgb, hsv, hsl }

class HSVColorPainter extends CustomPainter {
  const HSVColorPainter(this.hsvColor, {this.pointerColor});

  final HSVColor hsvColor;
  final Color? pointerColor;

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;
    const Gradient gradientV = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Colors.white, Colors.black],
    );
    final Gradient gradientH = LinearGradient(
      colors: [
        Colors.white,
        HSVColor.fromAHSV(1.0, hsvColor.hue, 1.0, 1.0).toColor(),
      ],
    );
    canvas.drawRect(rect, Paint()..shader = gradientV.createShader(rect));
    canvas.drawRect(
      rect,
      Paint()
        ..blendMode = BlendMode.multiply
        ..shader = gradientH.createShader(rect),
    );

    canvas.drawCircle(
      Offset(
          size.width * hsvColor.saturation, size.height * (1 - hsvColor.value)),
      size.height * 0.04,
      Paint()
        ..color = pointerColor ??
            (useWhiteForeground(hsvColor.toColor())
                ? Colors.white
                : Colors.black)
        ..strokeWidth = 1.5
        ..style = PaintingStyle.stroke,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class HSLColorPainter extends CustomPainter {
  const HSLColorPainter(this.hslColor, {this.pointerColor});

  final HSLColor hslColor;
  final Color? pointerColor;

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;
    final Gradient gradientH = LinearGradient(
      colors: [
        const Color(0xff808080),
        HSLColor.fromAHSL(1.0, hslColor.hue, 1.0, 0.5).toColor(),
      ],
    );
    const Gradient gradientV = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      stops: [0.0, 0.5, 0.5, 1],
      colors: [
        Colors.white,
        Color(0x00ffffff),
        Colors.transparent,
        Colors.black,
      ],
    );
    canvas.drawRect(rect, Paint()..shader = gradientH.createShader(rect));
    canvas.drawRect(rect, Paint()..shader = gradientV.createShader(rect));

    canvas.drawCircle(
      Offset(size.width * hslColor.saturation,
          size.height * (1 - hslColor.lightness)),
      size.height * 0.04,
      Paint()
        ..color = pointerColor ??
            (useWhiteForeground(hslColor.toColor())
                ? Colors.white
                : Colors.black)
        ..strokeWidth = 1.5
        ..style = PaintingStyle.stroke,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class _SliderLayout extends MultiChildLayoutDelegate {
  static const String text = 'text';
  static const String track = 'track';
  static const String thumb = 'thumb';
  static const String gestureContainer = 'gesturecontainer';

  @override
  void performLayout(Size size) {
    //color bar
    layoutChild(
      track,
      BoxConstraints.tightFor(
          width: size.width * 0.9, height: size.height * 0.5),
    );
    //color bar shift
    positionChild(track, Offset(size.width * 0.05, 0));
    //thumb
    layoutChild(
        thumb,
        BoxConstraints.tightFor(
            width: 15.0, height: size.height * 0.27) //enlarge width
        );
    //thumb shift
    positionChild(thumb, Offset(0, size.height * 0.55)); //shift down
    //gesture
    layoutChild(
      gestureContainer,
      BoxConstraints.tightFor(width: size.width, height: size.height),
    );
    //gesture shift
    positionChild(gestureContainer, Offset(0, size.height * 0.47));
  }

  @override
  bool shouldRelayout(_SliderLayout oldDelegate) => false;
}

class _SliderLayoutCustom extends MultiChildLayoutDelegate {
  static const String text = 'text';
  static const String track = 'track';
  static const String thumb = 'thumb';
  static const String gestureContainer = 'gesturecontainer';

  @override
  void performLayout(Size size) {
    //text
    layoutChild(
      text,
      BoxConstraints.tightFor(width: size.width, height: size.height * 0.2),
    );
    //text shift
    positionChild(text, const Offset(0, 0));

    //color bar
    layoutChild(
      track,
      BoxConstraints.tightFor(
          width: size.width * 0.9, height: size.height * 0.3),
    );
    //color bar shift
    positionChild(track, Offset(size.width * 0.05, size.height * 0.33));
    //thumb
    layoutChild(
        thumb,
        BoxConstraints.tightFor(
            width: 15.0, height: size.height * 0.18) //enlarge width
        );
    //thumb shift
    positionChild(thumb, Offset(0, size.height * 0.69)); //shift down
    //gesture
    layoutChild(
      gestureContainer,
      BoxConstraints.tightFor(width: size.width, height: size.height * 2),
    );
    //gesture shift
    positionChild(gestureContainer, Offset(0, size.height * 0.675));
  }

  @override
  bool shouldRelayout(_SliderLayoutCustom oldDelegate) => false;
}

class MyTextPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // final Rect rect = Offset.zero & size;
    TextPainter(
        text: const TextSpan(
            text: '10',
            style: TextStyle(fontSize: 16.0, color: Color(0XFFF05A24))),
        textDirection: TextDirection.ltr)
      ..layout(maxWidth: size.width, minWidth: size.width)
      ..paint(canvas, const Offset(0.0, 0.0));
    TextPainter(
        text: const TextSpan(
            text: '70',
            style: TextStyle(fontSize: 16.0, color: Color(0XFFF05A24))),
        textDirection: TextDirection.ltr)
      ..layout(maxWidth: size.width, minWidth: size.width)
      ..paint(canvas, Offset(size.width * 0.65, 0.0));
    TextPainter(
        text: const TextSpan(
            text: '100',
            style: TextStyle(fontSize: 16.0, color: Color(0XFFF05A24))),
        textDirection: TextDirection.ltr)
      ..layout(maxWidth: size.width, minWidth: size.width)
      ..paint(canvas, Offset(size.width * 0.88, 0.0));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class TrackPainter extends CustomPainter {
  const TrackPainter(this.trackType, this.hsvColor);

  final TrackType trackType;
  final HSVColor hsvColor;

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;
    if (trackType == TrackType.alpha) {
      final Size chessSize = Size(size.height / 2, size.height / 2);
      Paint chessPaintB = Paint()..color = const Color(0xffcccccc);
      Paint chessPaintW = Paint()..color = Colors.white;
      List.generate((size.height / chessSize.height).round(), (int y) {
        List.generate((size.width / chessSize.width).round(), (int x) {
          canvas.drawRect(
            Offset(chessSize.width * x, chessSize.width * y) & chessSize,
            (x + y) % 2 != 0 ? chessPaintW : chessPaintB,
          );
        });
      });
    }

    switch (trackType) {
      case TrackType.hue:
        final List<Color> colors = [
          const HSVColor.fromAHSV(1.0, 0.0, 1.0, 1.0).toColor(),
          const HSVColor.fromAHSV(1.0, 60.0, 1.0, 1.0).toColor(),
          const HSVColor.fromAHSV(1.0, 120.0, 1.0, 1.0).toColor(),
          const HSVColor.fromAHSV(1.0, 180.0, 1.0, 1.0).toColor(),
          const HSVColor.fromAHSV(1.0, 240.0, 1.0, 1.0).toColor(),
          const HSVColor.fromAHSV(1.0, 300.0, 1.0, 1.0).toColor(),
          const HSVColor.fromAHSV(1.0, 360.0, 1.0, 1.0).toColor(),
        ];
        Gradient gradient = LinearGradient(colors: colors);
        canvas.drawRect(rect, Paint()..shader = gradient.createShader(rect));
        break;
      case TrackType.saturation:
        final List<Color> colors = [
          HSVColor.fromAHSV(1.0, hsvColor.hue, 0.0, 1.0).toColor(),
          HSVColor.fromAHSV(1.0, hsvColor.hue, 1.0, 1.0).toColor(),
        ];
        Gradient gradient = LinearGradient(colors: colors);
        canvas.drawRect(rect, Paint()..shader = gradient.createShader(rect));
        break;
      case TrackType.custom:
        //draw broader
        canvas.drawRect(rect, Paint()..color = const Color(0xffB4B4B4));

        final List<Color> colors = [
          HSVColor.fromAHSV(1.0, hsvColor.hue, 1.0, 1.0).toColor(),
          HSVColor.fromAHSV(1.0, hsvColor.hue, 0.0, 1.0).toColor(),
        ];
        Gradient gradient = LinearGradient(colors: colors);
        canvas.drawRect(
            const Offset(1, 1) & Size(size.width - 2, size.height - 2),
            Paint()..shader = gradient.createShader(rect));
        break;
      case TrackType.saturationForHSL:
        final List<Color> colors = [
          HSLColor.fromAHSL(1.0, hsvColor.hue, 0.0, 0.5).toColor(),
          HSLColor.fromAHSL(1.0, hsvColor.hue, 1.0, 0.5).toColor(),
        ];
        Gradient gradient = LinearGradient(colors: colors);
        canvas.drawRect(rect, Paint()..shader = gradient.createShader(rect));
        break;
      case TrackType.value:
        final List<Color> colors = [
          HSVColor.fromAHSV(1.0, hsvColor.hue, 1.0, 0.0).toColor(),
          HSVColor.fromAHSV(1.0, hsvColor.hue, 1.0, 1.0).toColor(),
        ];
        Gradient gradient = LinearGradient(colors: colors);
        canvas.drawRect(rect, Paint()..shader = gradient.createShader(rect));
        break;
      case TrackType.lightness:
        final List<Color> colors = [
          HSLColor.fromAHSL(1.0, hsvColor.hue, 1.0, 0.0).toColor(),
          HSLColor.fromAHSL(1.0, hsvColor.hue, 1.0, 0.5).toColor(),
          HSLColor.fromAHSL(1.0, hsvColor.hue, 1.0, 1.0).toColor(),
        ];
        Gradient gradient = LinearGradient(colors: colors);
        canvas.drawRect(rect, Paint()..shader = gradient.createShader(rect));
        break;
      case TrackType.red:
        final List<Color> colors = [
          hsvColor.toColor().withRed(0).withOpacity(1.0),
          hsvColor.toColor().withRed(255).withOpacity(1.0),
        ];
        Gradient gradient = LinearGradient(colors: colors);
        canvas.drawRect(rect, Paint()..shader = gradient.createShader(rect));
        break;
      case TrackType.green:
        final List<Color> colors = [
          hsvColor.toColor().withGreen(0).withOpacity(1.0),
          hsvColor.toColor().withGreen(255).withOpacity(1.0),
        ];
        Gradient gradient = LinearGradient(colors: colors);
        canvas.drawRect(rect, Paint()..shader = gradient.createShader(rect));
        break;
      case TrackType.blue:
        final List<Color> colors = [
          hsvColor.toColor().withBlue(0).withOpacity(1.0),
          hsvColor.toColor().withBlue(255).withOpacity(1.0),
        ];
        Gradient gradient = LinearGradient(colors: colors);
        canvas.drawRect(rect, Paint()..shader = gradient.createShader(rect));
        break;
      case TrackType.alpha:
        final List<Color> colors = [
          Colors.black.withOpacity(0.0),
          Colors.black.withOpacity(1.0),
        ];
        Gradient gradient = LinearGradient(colors: colors);
        canvas.drawRect(rect, Paint()..shader = gradient.createShader(rect));
        break;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class ThumbPainter extends CustomPainter {
  const ThumbPainter({this.thumbColor, this.fullThumbColor = false});

  final Color? thumbColor;
  final bool fullThumbColor;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawShadow(
      Path()
        ..addOval(
          Rect.fromCircle(
              center: const Offset(0.5, 2.0), radius: size.width * 1.8),
        ),
      Colors.black,
      3.0,
      true,
    );
    canvas.drawCircle(
        Offset(0.0, size.height * 0.4),
        size.height,
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.fill);
    if (thumbColor != null) {
      canvas.drawCircle(
          Offset(0.0, size.height * 0.4),
          size.height * (fullThumbColor ? 1.0 : 0.65),
          Paint()
            ..color = thumbColor!
            ..style = PaintingStyle.fill);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class IndicatorPainter extends CustomPainter {
  const IndicatorPainter(
    this.color, {
    this.activate = true,
  });

  final Color color;
  final bool activate;

  @override
  void paint(Canvas canvas, Size size) {
    final Size chessSize = Size(size.width / 10, size.height / 10);
    final Paint chessPaintB = Paint()..color = const Color(0xFFCCCCCC);
    final Paint chessPaintW = Paint()..color = Colors.white;
    List.generate((size.height / chessSize.height).round(), (int y) {
      List.generate((size.width / chessSize.width).round(), (int x) {
        canvas.drawRect(
          Offset(chessSize.width * x, chessSize.height * y) & chessSize,
          (x + y) % 2 != 0 ? chessPaintW : chessPaintB,
        );
      });
    });

    canvas.drawPaint(chessPaintW);

    canvas.drawCircle(
        Offset(size.width / 2, size.height / 2),
        size.height / 2,
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.fill);

    canvas.drawCircle(
        Offset(size.width / 2, size.height / 2),
        size.height / 2 - 3,
        Paint()
          ..color = activate ? color : Colors.black26
          ..style = PaintingStyle.fill);

    if (!activate) {
      canvas.drawCircle(
          Offset(size.width / 2, size.height / 2),
          size.height / 2 - 4,
          Paint()
            ..color = Colors.white
            ..style = PaintingStyle.fill);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class CheckerPainter extends CustomPainter {
  const CheckerPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final Size chessSize = Size(size.height / 6, size.height / 6);
    Paint chessPaintB = Paint()..color = const Color(0xffcccccc);
    Paint chessPaintW = Paint()..color = Colors.white;
    List.generate((size.height / chessSize.height).round(), (int y) {
      List.generate((size.width / chessSize.width).round(), (int x) {
        canvas.drawRect(
          Offset(chessSize.width * x, chessSize.width * y) & chessSize,
          (x + y) % 2 != 0 ? chessPaintW : chessPaintB,
        );
      });
    });
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class ColorPickerLabel extends StatefulWidget {
  const ColorPickerLabel(
    this.hsvColor, {
    Key? key,
    this.enableAlpha = true,
    this.textStyle,
    this.editable = false, // TODO: TBD
    this.onColorChanged, // TODO: TBD
  }) : super(key: key);

  final HSVColor hsvColor;
  final bool enableAlpha;
  final TextStyle? textStyle;
  final bool editable;
  final ValueChanged<HSVColor>? onColorChanged;

  @override
  _ColorPickerLabelState createState() => _ColorPickerLabelState();
}

class _ColorPickerLabelState extends State<ColorPickerLabel> {
  final Map<ColorModel, List<String>> _colorTypes = {
    ColorModel.hex: ['R', 'G', 'B', 'A'],
    ColorModel.rgb: ['R', 'G', 'B', 'A'],
    ColorModel.hsv: ['H', 'S', 'V', 'A'],
    ColorModel.hsl: ['H', 'S', 'L', 'A'],
  };

  ColorModel _colorType = ColorModel.hex;

  List<String> colorValue(HSVColor hsvColor, ColorModel colorModel) {
    final Color color = hsvColor.toColor();
    if (colorModel == ColorModel.hex) {
      return [
        color.red.toRadixString(16).toUpperCase().padLeft(2, '0'),
        color.green.toRadixString(16).toUpperCase().padLeft(2, '0'),
        color.blue.toRadixString(16).toUpperCase().padLeft(2, '0'),
        '${(color.opacity * 100).round()}%',
      ];
    } else if (colorModel == ColorModel.rgb) {
      return [
        color.red.toString(),
        color.green.toString(),
        color.blue.toString(),
        '${(color.opacity * 100).round()}%',
      ];
    } else if (colorModel == ColorModel.hsv) {
      return [
        '${hsvColor.hue.round()}°',
        '${(hsvColor.saturation * 100).round()}%',
        '${(hsvColor.value * 100).round()}%',
        '${(hsvColor.alpha * 100).round()}%',
      ];
    } else if (colorModel == ColorModel.hsl) {
      HSLColor hslColor = hsvToHsl(hsvColor);
      return [
        '${hslColor.hue.round()}°',
        '${(hslColor.saturation * 100).round()}%',
        '${(hslColor.lightness * 100).round()}%',
        '${(hsvColor.alpha * 100).round()}%',
      ];
    } else {
      return ['??', '??', '??', '??'];
    }
  }

  List<Widget> colorValueLabels() {
    return [
      for (String item in _colorTypes[_colorType] ?? [])
        if (widget.enableAlpha || item != 'A')
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 7.0),
            child: IntrinsicHeight(
              child: Column(
                children: <Widget>[
                  Text(
                    item,
                    style: widget.textStyle ??
                        Theme.of(context).textTheme.bodyText2?.copyWith(
                            fontWeight: FontWeight.bold, fontSize: 16.0),
                  ),
                  const SizedBox(height: 10.0),
                  Expanded(
                    child: Text(
                      colorValue(widget.hsvColor, _colorType)[
                          _colorTypes[_colorType]!.indexOf(item)],
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
      DropdownButton(
        value: _colorType,
        onChanged: (ColorModel? type) {
          if (type != null) {
            setState(() => _colorType = type);
          }
        },
        items: [
          for (ColorModel type in _colorTypes.keys)
            DropdownMenuItem(
              value: type,
              child: Text(type.toString().split('.').last.toUpperCase()),
            )
        ],
      ),
      const SizedBox(width: 10.0),
      ...colorValueLabels(),
    ]);
  }
}

class ColorPickerSlider extends StatelessWidget {
  const ColorPickerSlider(
    this.trackType,
    this.hsvColor,
    this.onColorChanged, {
    Key? key,
    this.displayThumbColor = false,
    this.fullThumbColor = false,
    this.displayOnly = false,
    this.onProgressChanged,
  }) : super(key: key);

  final TrackType trackType;
  final HSVColor hsvColor;
  final ValueChanged<HSVColor> onColorChanged;
  final Function? onProgressChanged;
  final bool displayThumbColor;
  final bool fullThumbColor;
  final bool displayOnly;

  void slideEvent(RenderBox getBox, BoxConstraints box, Offset globalPosition) {
    if (displayOnly) return;
    double localDx = getBox.globalToLocal(globalPosition).dx - 15.0;
    double progress =
        localDx.clamp(0.0, box.maxWidth - 30.0) / (box.maxWidth - 30.0);
    switch (trackType) {
      case TrackType.hue:
        // 360 is the same as zero
        // if set to 360, sliding to end goes to zero
        onColorChanged(hsvColor.withHue(progress * 359));
        break;
      case TrackType.saturation:
        onColorChanged(hsvColor.withSaturation(progress));
        break;
      case TrackType.custom:
        if (onProgressChanged != null) onProgressChanged!(progress);
        onColorChanged(hsvColor.withSaturation(progress));
        break;
      case TrackType.saturationForHSL:
        onColorChanged(hslToHsv(hsvToHsl(hsvColor).withSaturation(progress)));
        break;
      case TrackType.value:
        onColorChanged(hsvColor.withValue(progress));
        break;
      case TrackType.lightness:
        onColorChanged(hslToHsv(hsvToHsl(hsvColor).withLightness(progress)));
        break;
      case TrackType.red:
        onColorChanged(HSVColor.fromColor(
            hsvColor.toColor().withRed((progress * 0xff).round())));
        break;
      case TrackType.green:
        onColorChanged(HSVColor.fromColor(
            hsvColor.toColor().withGreen((progress * 0xff).round())));
        break;
      case TrackType.blue:
        onColorChanged(HSVColor.fromColor(
            hsvColor.toColor().withBlue((progress * 0xff).round())));
        break;
      case TrackType.alpha:
        onColorChanged(hsvColor.withAlpha(
            localDx.clamp(0.0, box.maxWidth - 30.0) / (box.maxWidth - 30.0)));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (BuildContext context, BoxConstraints box) {
      double thumbOffset = 15.0;
      Color thumbColor;
      switch (trackType) {
        case TrackType.hue:
          thumbOffset += (box.maxWidth - 30.0) * hsvColor.hue / 360;
          thumbColor = HSVColor.fromAHSV(1.0, hsvColor.hue, 1.0, 1.0).toColor();
          break;
        case TrackType.saturation:
        case TrackType.custom:
          thumbOffset += (box.maxWidth - 30.0) * hsvColor.saturation;
          thumbColor =
              HSVColor.fromAHSV(1.0, hsvColor.hue, hsvColor.saturation, 1.0)
                  .toColor();
          break;
        case TrackType.saturationForHSL:
          thumbOffset += (box.maxWidth - 30.0) * hsvToHsl(hsvColor).saturation;
          thumbColor = HSLColor.fromAHSL(
                  1.0, hsvColor.hue, hsvToHsl(hsvColor).saturation, 0.5)
              .toColor();
          break;
        case TrackType.value:
          thumbOffset += (box.maxWidth - 30.0) * hsvColor.value;
          thumbColor = HSVColor.fromAHSV(1.0, hsvColor.hue, 1.0, hsvColor.value)
              .toColor();
          break;
        case TrackType.lightness:
          thumbOffset += (box.maxWidth - 30.0) * hsvToHsl(hsvColor).lightness;
          thumbColor = HSLColor.fromAHSL(
                  1.0, hsvColor.hue, 1.0, hsvToHsl(hsvColor).lightness)
              .toColor();
          break;
        case TrackType.red:
          thumbOffset += (box.maxWidth - 30.0) * hsvColor.toColor().red / 0xff;
          thumbColor = hsvColor.toColor().withOpacity(1.0);
          break;
        case TrackType.green:
          thumbOffset +=
              (box.maxWidth - 30.0) * hsvColor.toColor().green / 0xff;
          thumbColor = hsvColor.toColor().withOpacity(1.0);
          break;
        case TrackType.blue:
          thumbOffset += (box.maxWidth - 30.0) * hsvColor.toColor().blue / 0xff;
          thumbColor = hsvColor.toColor().withOpacity(1.0);
          break;
        case TrackType.alpha:
          thumbOffset += (box.maxWidth - 30.0) * hsvColor.toColor().opacity;
          thumbColor = Colors.black.withOpacity(hsvColor.alpha);
          break;
      }

      return trackType == TrackType.custom
          ? customLayout(thumbOffset)
          : normalLayout(thumbOffset);
    });
  }

  Widget customLayout(double thumbOffset) {
    return CustomMultiChildLayout(
      delegate: _SliderLayoutCustom(),
      children: <Widget>[
        LayoutId(
          id: _SliderLayout.text,
          child: ClipRRect(
            child: CustomPaint(
              painter: MyTextPainter(),
            ),
          ),
        ),
        LayoutId(
          id: _SliderLayout.track,
          child: ClipRRect(
            child: CustomPaint(
              painter: TrackPainter(
                trackType,
                hsvColor,
              ),
            ),
          ),
        ),
        LayoutId(
          id: _SliderLayout.thumb,
          child: Transform.translate(
            offset: Offset(thumbOffset, 0.0),
            child: Visibility(
              child: CustomPaint(
                // size: const Size(10, 10),
                painter: TrianglePainter(
                  strokeColor: const Color(0xFFF05A24),
                  strokeWidth: 1,
                  paintingStyle: PaintingStyle.fill,
                ),
              ),
              visible: !displayOnly,
            ),
          ),
        ),
        LayoutId(
          id: _SliderLayout.gestureContainer,
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints box) {
              RenderBox? getBox = context.findRenderObject() as RenderBox?;
              return GestureDetector(
                onPanDown: (DragDownDetails details) => getBox != null
                    ? slideEvent(getBox, box, details.globalPosition)
                    : null,
                onPanUpdate: (DragUpdateDetails details) => getBox != null
                    ? slideEvent(getBox, box, details.globalPosition)
                    : null,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget normalLayout(double thumbOffset) {
    return CustomMultiChildLayout(
      delegate: _SliderLayout(),
      children: <Widget>[
        LayoutId(
          id: _SliderLayout.track,
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(2.0)),
            child: CustomPaint(
              painter: TrackPainter(
                trackType,
                hsvColor,
              ),
            ),
          ),
        ),
        LayoutId(
          id: _SliderLayout.thumb,
          child: Transform.translate(
            offset: Offset(thumbOffset, 0.0),
            child: Visibility(
              child: CustomPaint(
                painter: TrianglePainter(
                  strokeColor: const Color(0xFFF05A24),
                  strokeWidth: 1,
                  paintingStyle: PaintingStyle.fill,
                ),
              ),
              visible: !displayOnly,
            ),
          ),
        ),
        LayoutId(
          id: _SliderLayout.gestureContainer,
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints box) {
              RenderBox? getBox = context.findRenderObject() as RenderBox?;
              return GestureDetector(
                onPanDown: (DragDownDetails details) => getBox != null
                    ? slideEvent(getBox, box, details.globalPosition)
                    : null,
                onPanUpdate: (DragUpdateDetails details) => getBox != null
                    ? slideEvent(getBox, box, details.globalPosition)
                    : null,
              );
            },
          ),
        ),
      ],
    );
  }
}

class TrianglePainter extends CustomPainter {
  final Color strokeColor;
  final PaintingStyle paintingStyle;
  final double strokeWidth;

  TrianglePainter({
    this.strokeColor = Colors.black,
    this.strokeWidth = 3,
    this.paintingStyle = PaintingStyle.stroke,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = strokeColor
      ..strokeWidth = strokeWidth
      ..style = paintingStyle;

    canvas.drawPath(getTrianglePath(size.width, size.height), paint);
  }

  Path getTrianglePath(double x, double y) {
    return Path()
      ..moveTo(-x * 0.96, 1.2 * y)
      ..lineTo(x * 0.96, 1.2 * y)
      ..lineTo(0, 0)
      ..lineTo(-x * 0.96, 1.2 * y);
  }

  @override
  bool shouldRepaint(TrianglePainter oldDelegate) {
    return oldDelegate.strokeColor != strokeColor ||
        oldDelegate.paintingStyle != paintingStyle ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}

class ColorIndicator extends StatelessWidget {
  const ColorIndicator(
    this.hsvColor, {
    Key? key,
    this.width = 300.0,
    this.height = 65.0, //調整單一顏色圓圈大小
    this.onClick,
    this.activate = true,
    this.isSelected = false,
  }) : super(key: key);

  final HSVColor hsvColor;
  final double width;
  final double height;
  final Function? onClick;
  final bool isSelected;
  final bool activate;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(1000.0)),
          border: Border.all(
            color: (isSelected)
                ? const Color(0xFF3E3E3E)
                : const Color(0xFFFFFFFF),
            width: 1.0,
          ),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(1000.0)),
          child: CustomPaint(
            painter: IndicatorPainter(
              hsvColor.toColor(),
              activate: activate,
            ),
          ),
        ),
      ),
      onTap: () {
        if (activate && onClick != null) {
          onClick!();
        }
      },
    );
  }
}

class ColorPickerArea extends StatelessWidget {
  const ColorPickerArea(
    this.hsvColor,
    this.onColorChanged,
    this.paletteType, {
    Key? key,
  }) : super(key: key);

  final HSVColor hsvColor;
  final ValueChanged<HSVColor> onColorChanged;
  final PaletteType paletteType;

  void _handleColorChange(double horizontal, double vertical) {
    switch (paletteType) {
      case PaletteType.hsv:
        onColorChanged(hsvColor.withSaturation(horizontal).withValue(vertical));
        break;
      case PaletteType.hsl:
        onColorChanged(hslToHsv(hsvToHsl(hsvColor)
            .withSaturation(horizontal)
            .withLightness(vertical)));
        break;
      default:
        break;
    }
  }

  void _handleGesture(
      Offset position, BuildContext context, double height, double width) {
    RenderBox? getBox = context.findRenderObject() as RenderBox?;
    if (getBox == null) {
      return;
    }
    Offset localOffset = getBox.globalToLocal(position);
    double horizontal = localOffset.dx.clamp(0.0, width) / width;
    double vertical = 1 - localOffset.dy.clamp(0.0, height) / height;
    _handleColorChange(horizontal, vertical);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        double width = constraints.maxWidth;
        double height = constraints.maxHeight;

        return RawGestureDetector(
          gestures: {
            AlwaysWinPanGestureRecognizer: GestureRecognizerFactoryWithHandlers<
                AlwaysWinPanGestureRecognizer>(
              () => AlwaysWinPanGestureRecognizer(),
              (AlwaysWinPanGestureRecognizer instance) {
                instance
                  ..onDown = ((details) => _handleGesture(
                      details.globalPosition, context, height, width))
                  ..onUpdate = ((details) => _handleGesture(
                      details.globalPosition, context, height, width));
              },
            ),
          },
          child: Builder(
            builder: (BuildContext _) {
              switch (paletteType) {
                case PaletteType.hsv:
                  return CustomPaint(painter: HSVColorPainter(hsvColor));
                case PaletteType.hsl:
                  return CustomPaint(
                      painter: HSLColorPainter(hsvToHsl(hsvColor)));
                default:
                  return const CustomPaint();
              }
            },
          ),
        );
      },
    );
  }
}

class AlwaysWinPanGestureRecognizer extends PanGestureRecognizer {
  @override
  void addAllowedPointer(event) {
    super.addAllowedPointer(event);
    resolve(GestureDisposition.accepted);
  }

  @override
  String get debugDescription => 'alwaysWin';
}
