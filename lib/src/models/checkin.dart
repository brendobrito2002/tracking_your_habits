import 'package:hive/hive.dart';

part 'checkin.g.dart';

@HiveType(typeId: 2)
class CheckIn extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String habitId;

  @HiveField(2)
  final String userId;

  @HiveField(3)
  final DateTime date;

  CheckIn({
    required this.id,
    required this.habitId,
    required this.userId,
    required this.date,
  });
}