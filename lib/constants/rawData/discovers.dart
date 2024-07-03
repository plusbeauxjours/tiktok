import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok/features/discover/screens/discover_screen.dart';
import 'package:tiktok/features/inbox/screens/inbox_screen.dart';
import 'package:tiktok/features/users/screens/user_profile_screen.dart';
import 'package:tiktok/features/videos/views/video_timeline_screen.dart';

final List<String> tabs = [
  'Top',
  "users",
  'Videos',
  'Sounds',
  'LIVE',
  'Shopping',
  'Brands',
];

final List<String> discoveredImages = [
  'assets/images/christmas-tree-6847584.jpg',
  'assets/images/crane-houses-7518551.jpg',
  'assets/images/dinner-7736494.jpg',
  'assets/images/dog-7535633.jpg',
  'assets/images/durham-7539264.jpg',
  'assets/images/flower-7659988.jpg',
  'assets/images/flower-7696955.jpg',
  'assets/images/hall-7568043.jpg',
  'assets/images/heron-7671357.jpg',
  'assets/images/ice-cream-7661889.jpg',
  'assets/images/labor-7576514.jpg',
  'assets/images/phone-wallpaper-6496638.jpg',
  'assets/images/phone-wallpaper-7105626.jpg',
  'assets/images/snow-7670491.jpg',
  'assets/images/street-6884534.jpg',
  'assets/images/viet-nam-7741017.jpg',
  'assets/images/water-7555693.jpg',
  'assets/images/white-faced-heron-7469267.jpg',
  'assets/images/windmill-7367963.jpg',
  'assets/images/winter-forest-7677111.jpg',
];

List<Widget> offStages = [
  const VideoTimelineScreen(),
  const DiscoverScreen(),
  Container(),
  const InboxScreen(),
  const UserProfileScreen(username: '', tab: ''),
];

List<Widget> offStages2 = [
  const VideoTimelineScreen(),
  const DiscoverScreen(),
  const InboxScreen(),
  const UserProfileScreen(username: '', tab: ''),
];

List<dynamic> navs = [
  {
    'title': 'Home',
    'icon': FontAwesomeIcons.house,
  },
  {
    'title': 'Discover',
    'icon': FontAwesomeIcons.compass,
  },
  {
    'title': 'Add Video',
    'icon': FontAwesomeIcons.plus,
  },
  {
    'title': 'Inbox',
    'icon': FontAwesomeIcons.solidMessage,
  },
  {
    'title': 'Profile',
    'icon': FontAwesomeIcons.solidUser,
  },
];

List<dynamic> navs2 = [
  {
    'title': 'Home',
    'icon': FontAwesomeIcons.house,
  },
  {
    'title': 'Discover',
    'icon': FontAwesomeIcons.compass,
  },
  {
    'title': 'Inbox',
    'icon': FontAwesomeIcons.solidMessage,
  },
  {
    'title': 'Profile',
    'icon': FontAwesomeIcons.solidUser,
  },
];
