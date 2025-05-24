import 'package:flutter/material.dart';

class ImagePlaceholder extends StatelessWidget {
  final double width;
  final double height;

  const ImagePlaceholder({this.width = 50, this.height = 50, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      color: Colors.grey.shade300,
      alignment: Alignment.center,
      child: const Text(
        "<EXAMPLE_IMAGE>",
        style: TextStyle(fontSize: 10, color: Colors.black54),
        textAlign: TextAlign.center,
      ),
    );
  }
}
