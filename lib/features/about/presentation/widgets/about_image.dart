import 'package:flutter/material.dart';

class AboutImage extends StatelessWidget {
  final String url;
  final double height;

  const AboutImage({
    super.key,
    required this.url,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.network(
        url,
        width: double.infinity,
        height: height,
        fit: BoxFit.cover,
      ),
    );
  }
}
