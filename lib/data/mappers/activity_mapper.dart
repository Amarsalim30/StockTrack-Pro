import '../../domain/entities/activity.dart';
import '../models/activity/activity_model.dart';

class ActivityMapper {
  static Activity toEntity(ActivityModel model) {
    return Activity(
      id: model.id,
      userId: model.userId,
      userName: model.userName,
      type: model.type,
      action: model.action,
      description: model.description,
      metadata: model.metadata,
      timestamp: model.timestamp,
      ipAddress: model.ipAddress,
      deviceInfo: model.deviceInfo,
    );
  }

  static ActivityModel toModel(Activity entity) {
    return ActivityModel(
      id: entity.id,
      userId: entity.userId,
      userName: entity.userName,
      type: entity.type,
      action: entity.action,
      description: entity.description,
      metadata: entity.metadata,
      timestamp: entity.timestamp,
      ipAddress: entity.ipAddress,
      deviceInfo: entity.deviceInfo,
    );
  }

  static List<Activity> toEntityList(List<ActivityModel> models) {
    return models.map((model) => toEntity(model)).toList();
  }

  static List<ActivityModel> toModelList(List<Activity> entities) {
    return entities.map((entity) => toModel(entity)).toList();
  }
}
