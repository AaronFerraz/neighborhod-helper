import 'package:flutter/material.dart';
import '../presentation/post_creation_screen/post_creation_screen.dart';
import '../presentation/login_screen/login_screen.dart';
import '../presentation/profile_screen/profile_screen.dart';
import '../presentation/urgent_alerts_screen/urgent_alerts_screen.dart';
import '../presentation/community_feed_screen/community_feed_screen.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String postCreation = '/post-creation-screen';
  static const String login = '/login-screen';
  static const String profile = '/profile-screen';
  static const String urgentAlerts = '/urgent-alerts-screen';
  static const String communityFeed = '/community-feed-screen';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const LoginScreen(),
    postCreation: (context) => const PostCreationScreen(),
    login: (context) => const LoginScreen(),
    profile: (context) => const ProfileScreen(),
    urgentAlerts: (context) => const UrgentAlertsScreen(),
    communityFeed: (context) => const CommunityFeedScreen(),
    // TODO: Add your other routes here
  };
}