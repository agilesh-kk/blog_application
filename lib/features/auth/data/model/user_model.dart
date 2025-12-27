import 'package:blog_app/core/common/entities/user.dart';

class UserModel extends User {
  UserModel({required super.id, required super.name, required super.email});

  factory UserModel.fromJson(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '', 
      
      //to get the user's name from the usermetadata since it is not getting updated in the appusercubit.
      name: map['name'] ?? map['raw_user_meta_data']?['name'] ?? map['user_metadata']?['name'] ?? '',  
      email: map['email'] ?? '',
    );
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
    );
  }
}

