import 'package:flutter/material.dart';
import 'package:meet_explore/features/contacts/presentation/screens/contacts_screen.dart';
import '../features/events/presentation/screens/events_screen.dart';
import '../features/events/presentation/screens/events_participating_screen.dart';
import '../features/events/presentation/screens/event_detail_screen.dart';
import '../features/about/presentation/screens/about_screen.dart';
import 'package:meet_explore/features/auth/presentation/screens/login_screen.dart';
import 'package:meet_explore/features/auth/presentation/screens/sign_up_screen.dart';

class AppRoutes {
  static const events = '/events';
  static const participatingEvents = '/events-participating';
  static const eventDetail = '/event-detail';
  static const about = '/about';
  static const contacts = '/contacts';
  static const login = '/login';
  static const signup = '/signup';

  static Map<String, Widget Function(BuildContext)> routes = {
    events: (_) => const EventsScreen(),
    participatingEvents: (_) => const EventsParticipatingScreen(),
    about: (_) => const AboutScreen(),
    contacts: (_) => const ContactsScreen(),
    login: (_) => const LoginScreen(),
    signup: (_) => const SignUpScreen(),
  };

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case eventDetail:
        final eventId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => EventDetailScreen(eventId: eventId),
        );
      default:
        return MaterialPageRoute(builder: (_) => const EventsScreen());
    }
  }
}
