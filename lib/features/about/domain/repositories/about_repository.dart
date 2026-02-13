import '../entities/about_info.dart';

abstract class AboutRepository {
  Future<AboutInfo> getAboutInfo();
}
