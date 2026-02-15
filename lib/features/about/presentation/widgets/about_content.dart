import 'package:flutter/material.dart';
import '../../../contacts/presentation/widgets/social_section.dart';
import '../../domain/entities/about_info.dart';
import 'about_image.dart';
import 'about_text_section.dart';

class AboutContent extends StatelessWidget {
  final AboutInfo about;

  const AboutContent({super.key, required this.about});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AboutImage(url: about.headerImageUrl, height: 200),
          const SizedBox(height: 16),

          AboutTextSection(title: about.title, text: about.paragraph1),

          const SizedBox(height: 16),

          AboutImage(url: about.middleImageUrl, height: 250),

          const SizedBox(height: 16),

          AboutTextSection(text: about.paragraph2),

          const SizedBox(height: 16),

          AboutImage(url: about.footerImageUrl, height: 200),
          const SizedBox(height: 24),
          const SocialSection(),
        ],
      ),
    );
  }
}
