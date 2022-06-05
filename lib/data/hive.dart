import 'package:hive_flutter/hive_flutter.dart';

part 'hive.g.dart';

@HiveType(typeId: 0)
class StoreIndex extends HiveObject {

  @HiveField(1)
  final bool isLoggedIn;

  StoreIndex({
    required this.isLoggedIn,
  });
}
