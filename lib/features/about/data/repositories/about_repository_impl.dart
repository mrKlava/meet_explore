import '../../domain/entities/about_info.dart';
import '../../domain/repositories/about_repository.dart';

class AboutRepositoryImpl implements AboutRepository {
  @override
  Future<AboutInfo> getAboutInfo() async {
    return AboutInfo(
      title: 'Welcome to Meet & Explore Pau!',
      paragraph1:
          'This app is designed to help people in and around Pau '
          'connect, discover local events, and make new friends. '
          'Whether you enjoy outdoor activities, music nights, theater, '
          'or casual meetups, there is something for everyone!',
      paragraph2:
          'Our goal is to create a friendly community where you can '
          'participate in local events, learn new skills, and have fun. '
          'Stay tuned for updates and new features coming soon!',
      headerImageUrl: 'https://picsum.photos/600/200?random=11',
      middleImageUrl: 'https://picsum.photos/600/250?random=12',
      footerImageUrl: 'https://picsum.photos/600/200?random=13',
    );
  }
}
