import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class SocialButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String url;

  const SocialButton({
    super.key,
    required this.icon,
    required this.color,
    required this.url,
  });

  Future<void> _launch(String url, BuildContext context) async {
    try {
      if (!await launchUrlString(
        url,
        mode: LaunchMode.externalApplication,
      )) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Could not open $url')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _launch(url, context),
      borderRadius: BorderRadius.circular(50),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, color: Colors.white, size: 28),
      ),
    );
  }
}
