import '../../domain/entities/about_info.dart';
import '../../domain/repositories/about_repository.dart';

class AboutRepositoryImpl implements AboutRepository {
  @override
  Future<AboutInfo> getAboutInfo() async {
    return AboutInfo(
      title: 'Welcome to Meet & Explore Pau!',
      paragraph1:
          '〽️Meet & Explore is a local events platform in Pau, France, designed to help students, expats, travelers, and young professionals discover social activities and community gatherings in one place. Our app makes it easy to find upcoming events in Pau — from hiking in the Pyrenees and outdoor adventures to cultural meetups, language exchange events, board game nights, beach trips, and social hangouts.',
      paragraph2:
          'Our goal is to create a friendly community where you can '
          'participate in local events, learn new skills, and have fun. '
          'Stay tuned for updates and new features coming soon!',
      headerImageUrl: 'https://firebasestorage.googleapis.com/v0/b/meet-explore-project.firebasestorage.app/o/assets%2Fabout_main.jpeg?alt=media&token=cf985fc2-bcf0-42a5-a924-51407bd1b619',
      middleImageUrl: 'https://firebasestorage.googleapis.com/v0/b/meet-explore-project.firebasestorage.app/o/assets%2Fabout_mid.png?alt=media&token=23af99d8-4a8b-4822-bdf9-b566b2fda731',
      footerImageUrl: 'https://firebasestorage.googleapis.com/v0/b/meet-explore-project.firebasestorage.app/o/assets%2Fabout_end.png?alt=media&token=e655b5e9-3b8b-441e-a2a8-ddc32736316c',
    );
  }
}
