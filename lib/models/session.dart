import 'package:flutter/material.dart';
import 'classes.dart';

class Session {
  String day;
  Classroom classroom;
  TimeOfDay start;
  TimeOfDay end;
  Session({
    required this.day,
    required this.classroom,
    required this.start,
    required this.end,
  });
}
