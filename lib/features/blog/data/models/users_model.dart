import 'dart:convert';
import 'package:blog_app/features/blog/domain/entities/users.dart';

class UsersModel extends Users{
  UsersModel({required super.id, required super.name});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
    };
  }

  factory UsersModel.fromMap(Map<String, dynamic> map) {
    return UsersModel(
      id: map['id'] as String,
      name: map['name'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory UsersModel.fromJson(String source) => UsersModel.fromMap(json.decode(source) as Map<String, dynamic>);

}