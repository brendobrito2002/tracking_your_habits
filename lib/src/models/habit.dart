import 'package:hive/hive.dart';

part 'habit.g.dart';

@HiveType(typeId: 1)
class Habit extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final String frequency;

  @HiveField(4)
  final List<int> customDays;

  Habit({
    required this.id,
    required this.name,
    required this.description,
    required this.frequency,
    this.customDays = const [],
  });
}