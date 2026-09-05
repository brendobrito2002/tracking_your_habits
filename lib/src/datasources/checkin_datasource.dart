import 'package:hive/hive.dart';

import '../models/checkin.dart';

class CheckInDataSource {
  final Box<CheckIn> _checkInBox;

  CheckInDataSource({
    Box<CheckIn>? checkInBox,
  }) : _checkInBox = checkInBox ?? Hive.box<CheckIn>('checkins');

  List<CheckIn> getCheckIns(String userId) {
    return _checkInBox.values
        .where((checkIn) => checkIn.userId == userId)
        .toList();
  }

  CheckIn? getCheckIn(
      String habitId,
      String userId,
      DateTime date,
      ) {
    for (final checkIn in _checkInBox.values) {
      if (checkIn.habitId == habitId &&
          checkIn.userId == userId &&
          _isSameDay(checkIn.date, date)) {
        return checkIn;
      }
    }

    return null;
  }

  Future<void> addCheckIn(CheckIn checkIn) async {
    await _checkInBox.put(checkIn.id, checkIn);
  }

  Future<void> deleteCheckIn(String id) async {
    await _checkInBox.delete(id);
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year &&
        a.month == b.month &&
        a.day == b.day;
  }
}