/// Extension cho DateTime để xác định buổi trong ngày
/// Sử dụng logic thời gian phù hợp với hệ thống background của app
extension DateTimeExtension on DateTime {
  /// Xác định buổi trong ngày dựa trên thời gian hiện tại
  TimeOfDayPeriod get timeOfDayPeriod {
    final hour = this.hour;
    final minute = this.minute;
    final totalMinutes = hour * 60 + minute;
    // Chuyển đổi thời gian thành phút để so sánh dễ dàng hơn
    const morningStart = 5 * 60;
    const nightStart = 19 * 60;
    if (totalMinutes >= morningStart && totalMinutes < nightStart) {
      return TimeOfDayPeriod.morning;
    } else {
      return TimeOfDayPeriod.night;
    }
  }

  /// Kiểm tra xem có phải là buổi sáng không
  bool get isMorning => timeOfDayPeriod == TimeOfDayPeriod.morning;

  /// Kiểm tra xem có phải là buổi tối không
  bool get isNight => timeOfDayPeriod == TimeOfDayPeriod.night;

  /// Trả về tên buổi trong ngày bằng tiếng Việt
  String get timeOfDayName => timeOfDayPeriod.displayName;

  String get currentTimeRange => timeOfDayPeriod.timeRange;

  String get timeOfDayIcon => timeOfDayPeriod.icon;

  Duration get timeUntilNextPeriod {
    final now = this;
    final currentPeriod = timeOfDayPeriod;

    DateTime nextPeriodTime;

    switch (currentPeriod) {
      case TimeOfDayPeriod.morning:
        // Từ sáng đến chiều (16:30)
        nextPeriodTime = DateTime(now.year, now.month, now.day, 16, 30);
        break;
      case TimeOfDayPeriod.night:
        if (now.hour >= 19) {
          nextPeriodTime = DateTime(now.year, now.month, now.day + 1, 5, 30);
        } else {
          nextPeriodTime = DateTime(now.year, now.month, now.day, 5, 30);
        }
        break;
    }

    return nextPeriodTime.difference(now);
  }

  /// Trả về buổi tiếp theo
  TimeOfDayPeriod get nextTimeOfDayPeriod {
    switch (timeOfDayPeriod) {
      case TimeOfDayPeriod.morning:
        return TimeOfDayPeriod.night;
      case TimeOfDayPeriod.night:
        return TimeOfDayPeriod.morning;
    }
  }

  /// Kiểm tra xem có phải là thời gian chuyển đổi giữa các buổi không
  /// (trong vòng 30 phút trước khi chuyển buổi)
  bool get isTransitionTime {
    final timeUntilNext = timeUntilNextPeriod;
    return timeUntilNext.inMinutes <= 30 && timeUntilNext.inMinutes >= 0;
  }
}

/// Enum để xác định các buổi trong ngày
/// Được sử dụng cho hệ thống background và theme theo thời gian
enum TimeOfDayPeriod {
  morning,
  night,
}

/// Extension cho TimeOfDayPeriod để cung cấp các tiện ích bổ sung
extension TimeOfDayPeriodExtension on TimeOfDayPeriod {
  /// Trả về tên hiển thị của buổi trong ngày bằng tiếng Việt
  String get displayName {
    switch (this) {
      case TimeOfDayPeriod.morning:
        return 'Buổi sáng';
      case TimeOfDayPeriod.night:
        return 'Buổi tối';
    }
  }

  /// Trả về mô tả thời gian của buổi trong ngày
  String get timeRange {
    switch (this) {
      case TimeOfDayPeriod.morning:
        return '5:30 - 16:30';
      case TimeOfDayPeriod.night:
        return '19:00 - 5:30';
    }
  }

  /// Trả về icon phù hợp cho buổi trong ngày
  String get icon {
    switch (this) {
      case TimeOfDayPeriod.morning:
        return '🌅';
      case TimeOfDayPeriod.night:
        return '🌙';
    }
  }

  /// Kiểm tra xem có phải là buổi tối không (để xử lý theme tối)
  bool get isNightTime => this == TimeOfDayPeriod.night;

  /// Kiểm tra xem có phải là buổi sáng không
  bool get isMorningTime => this == TimeOfDayPeriod.morning;
}
