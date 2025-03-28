import 'package:aigenda_mobile/utils/constants/firebase_constants.dart';

import '../../../models/task_model.dart';
import '../firebase_crud_service.dart';

class TaskService extends FirestoreCrudService<Task> {
  TaskService()
      : super(
          collectionPath: FirebaseConstant.taskCollection,
          fromMap: (doc) => Task.fromMap(doc),
          toMap: (task) => task.toMap(),
        );
}
