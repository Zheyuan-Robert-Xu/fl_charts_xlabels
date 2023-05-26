// flutter import
import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

// project import

class HoverText extends StatefulWidget {
  final String text;

  HoverText({required this.text});

  @override
  _HoverTextState createState() => _HoverTextState();
}

class _HoverTextState extends State<HoverText> {
  bool _isHovered = false;
  Color _tooltipColor = Color(0xFFF2F4FC);
  Color kPrimaryColor = Color(0xFF6F35A5);
  Color kBgLightColor = Color(0xFFF2F4FC);
  double bigXRayTextSize = 18.0;

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return MouseRegion(
        onEnter: (event) => setState(() => _isHovered = true),
        onExit: (event) => setState(() => _isHovered = false),
        child: Text(
          widget.text,
          style: TextStyle(
            color: _isHovered ? kPrimaryColor : kBgLightColor,
            fontWeight: FontWeight.bold,
            fontSize: bigXRayTextSize,
          ),
        ),
      );
    }
    if (Platform.isLinux || Platform.isMacOS || Platform.isWindows) {
      return MouseRegion(
        onEnter: (event) => setState(() => _isHovered = true),
        onExit: (event) => setState(() => _isHovered = false),
        child: Text(
          widget.text,
          style: TextStyle(
            color: _isHovered ? kPrimaryColor : kBgLightColor,
            fontWeight: FontWeight.bold,
            fontSize: bigXRayTextSize,
          ),
        ),
      );
    } else if (Platform.isAndroid || Platform.isIOS) {
      return GestureDetector(
        onTap: () {
          setState(() {
            _tooltipColor = kPrimaryColor;
          });
        },
        onDoubleTap: () {
          setState(() {
            _tooltipColor = kBgLightColor;
          });
        },
        child: Text(
          widget.text,
          style: TextStyle(
            color: _tooltipColor,
            fontWeight: FontWeight.bold,
            fontSize: bigXRayTextSize,
          ),
        ),
      );
    } else {
      return Text(
        widget.text,
        style: TextStyle(
          color: kPrimaryColor,
          fontWeight: FontWeight.bold,
          fontSize: bigXRayTextSize,
        ),
      );
    }
  }
}
