import 'package:objectbox/objectbox.dart';

@Entity()
class LocalDBModel {
  @Id()
  int id;

  final String data;

  LocalDBModel({this.id = 0, required this.data});
}
