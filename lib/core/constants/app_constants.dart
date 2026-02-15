import 'package:flutter/material.dart';

class AppColors {
  static const Color product = Color(0xFFFECA22);
  static const Color onPrimary = Colors.white;
  static const Color danger = Colors.red;
  static const Color fieldFill = Color(0xFFF5F5F5);
  static const Color shadow = Colors.black26;

  static const Color instagram = Color(0xFFE1306C);
  static const Color facebook = Color(0xFF1877F2);
  static const Color whatsapp = Color(0xFF25D366);
}

class AppDimens {
  static const double space4 = 4;
  static const double space6 = 6;
  static const double space8 = 8;
  static const double space10 = 10;
  static const double space12 = 12;
  static const double space16 = 16;
  static const double space24 = 24;

  static const double radius12 = 12;
  static const double radius16 = 16;
  static const double radius50 = 50;

  static const double eventCardImageHeight = 180;
  static const double eventDetailImageHeight = 250;
  static const double participatingEventImageHeight = 150;
  static const double bottomActionInset = 100;

  static const double icon16 = 16;
  static const double icon18 = 18;
  static const double icon28 = 28;

  static const double buttonVerticalPadding = 16;
  static const double elevation3 = 3;
  static const double elevation4 = 4;
  static const double elevation6 = 6;
}

class AppDateFormats {
  static const String eventDateTime = 'MMM dd, yyyy - HH:mm';
  static const String eventShortDateTime = 'MMM dd, HH:mm';
}

class AppAssets {
  static const String drawerHeader = 'assets/drawer_header.png';
}

class AppLinks {
  static const String instagram = 'https://www.instagram.com/meetexplorepau?utm_source=ig_web_button_share_sheet&igsh=ZDNlZDc0MzIxNw==';
  static const String facebook = 'https://facebook.com/groups/meetexplorepau';
  static const String whatsapp = 'https://chat.whatsapp.com/EQpscJ2fzDl6WlN04ZS3nQ';
}

class AppStrings {
  static const String appTitle = 'Meet & Explore Pau';
  static const String errorPrefix = 'Error';
  static const String authErrorPrefix = 'Auth error';
  static const String invalidEventId = 'Invalid event id.';

  static const String drawerEvents = 'Events';
  static const String drawerParticipating = 'Participating';
  static const String drawerAbout = 'About';
  static const String drawerContacts = 'Contacts';
  static const String drawerLogout = 'Logout';
  static const String drawerSignIn = 'Sign In';

  static const String signInTitle = 'Sign In';
  static const String signUpTitle = 'Sign Up';
  static const String loginFailed = 'Login failed';
  static const String signUpFailed = 'Sign Up failed';
  static const String dontHaveAccount = "Don't have an account? Sign Up";

  static const String fieldEmail = 'Email';
  static const String fieldPassword = 'Password';
  static const String validateEmail = 'Enter valid email';
  static const String validatePassword = 'Password must be at least 6 chars';

  static const String eventsTitle = 'Events';
  static const String eventsLoadFailed = 'Failed to load events';
  static const String eventsEmpty = 'No events available yet.';

  static const String participatingTitle = 'My Participating Events';
  static const String participatingEmpty =
      'You are not participating in any events yet.';

  static const String eventDetailsTitle = 'Event Details';
  static const String eventNotFound = 'Event not found';
  static const String hostedByPrefix = 'Hosted by';
  static const String free = 'Free';
  static const String participate = 'Participate';
  static const String cancelParticipation = 'Cancel Participation';
  static const String participationCancelled = 'You cancelled your participation.';
  static const String participationSuccess =
      'You are participating in this event.';
  static const String participationFailedPrefix =
      'Failed to update participation';

  static const String signInRequired = 'Sign In Required';
  static const String signInRequiredMessage =
      'You need to sign in to participate in events.';
  static const String cancel = 'Cancel';

  static const String aboutTitle = 'About';

  static const String contactTitle = 'Contact Us';
  static const String contactSuccess = 'Message sent successfully!';
  static const String contactErrorPrefix = 'Error';
  static const String connectWithUs = 'Connect with us:';
  static const String sendMessage = 'Send Message';
  static const String required = 'Required';
  static const String invalidEmail = 'Invalid email';
  static const String firstName = 'First Name';
  static const String lastName = 'Last Name';
  static const String message = 'Message';

  static const String couldNotOpenPrefix = 'Could not open';
}
