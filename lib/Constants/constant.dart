import 'package:adhyapak/Banking/banking.dart';
import 'package:adhyapak/Leaderboard/Leaderboard.dart';
import 'package:adhyapak/Notifications/notifications.dart';
import 'package:adhyapak/Profile/profile.dart';
import 'package:flutter/material.dart';

var subjects = [
  "English Literature",
  "English Language",
  "Hindi",
  "Physics",
  "Chemistry",
  "Biology",
  "History and Civics",
  "Geography",
  "Computer",
  "Economics",
  "Mathematics",
];

var list = [
  {
    "icon": Icon(Icons.settings),
    "title": "Profile",
    "class": Profile(),
  },
  {
    "icon": Icon(Icons.leaderboard_outlined),
    "title": 'Leader Board',
    "class": LeaderBoard(),
  },
  {
    "icon": Icon(Icons.notification_important),
    "title": "Notifications",
    "class": Notifications(),
  },
  {
    "icon": Icon(Icons.attach_money_outlined),
    "title": "Banking",
    "class": Banking(),
  },
];
