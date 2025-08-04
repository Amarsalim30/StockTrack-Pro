import '../../domain/entities/user.dart';
import '../models/user/user_model.dart';

class UserMapper {
  static User toEntity(UserModel model) {
    return User(
      id: model.id,
      name: model.name,
      email: model.email,
      role: model.role,
      phoneNumber: model.phoneNumber,
      department: model.department,
      permissions: model.permissions,
      isActive: model.isActive,
      lastLogin: model.lastLogin,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
    );
  }

  static UserModel toModel(User entity) {
    return UserModel(
      id: entity.id,
      name: entity.name,
      email: entity.email,
      role: entity.role,
      phoneNumber: entity.phoneNumber,
      department: entity.department,
      permissions: entity.permissions,
      isActive: entity.isActive,
      lastLogin: entity.lastLogin,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  static List<User> toEntityList(List<UserModel> models) {
    return models.map((model) => toEntity(model)).toList();
  }

  static List<UserModel> toModelList(List<User> entities) {
    return entities.map((entity) => toModel(entity)).toList();
  }
}
