// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:objectbox/objectbox.dart';

@Entity()
class UserDetailsModel {
  @Id()
  int? id;

  String? userId;

  String? userToken;

  String? email;

  String? userName;

  UserDetailsModel(
      {this.id, this.userId, this.userToken, this.email, this.userName});
}
