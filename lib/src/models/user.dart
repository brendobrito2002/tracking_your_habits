import 'package:hive/hive.dart';

part 'user.g.dart';

// HiveTybe é o código do tipo de arquivo, no caso tipo User
@HiveType(typeId: 0)
class User extends HiveObject {
  // HiveField se refere a posição do dado na tabela
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String email;

  @HiveField(3)
  int level;

  @HiveField(4)
  int experience;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.level = 1,
    this.experience = 0,
  });
}