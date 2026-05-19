import 'package:hive/hive.dart';

part 'game_hive_model.g.dart';

@HiveType(typeId: 0)
class GameHiveModel extends HiveObject {
  @HiveField(0)
  late int id;

  @HiveField(1)
  late String title;

  @HiveField(2)
  late String thumbnail;

  @HiveField(3)
  late String genre;

  @HiveField(4)
  late String platform;
}