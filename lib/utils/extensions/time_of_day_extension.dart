import 'package:flutter/material.dart';

extension NormalTime on TimeOfDay {
  String getTimeWithAmPm() {
    String minutes = minute.toString().padLeft(2, '0');
    if (hour >= 12) {
      return '$hour:$minutes PM';
    }
    return '$hour:$minutes AM';
  }

  TimeOfDay get12HoursTime() {
    if (period == DayPeriod.pm) {
      return replacing(hour: hour - 12, minute: minute);
    }
    return this;
  }
}
